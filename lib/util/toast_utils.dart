import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ToastType { info, success, warning, error }

class ToastUtils {
  ToastUtils._();

  static GlobalKey<NavigatorState>? _navigatorKey;
  static OverlayEntry? _entry;
  static _ToastCardState? _card;

  /// Must be called once with the app's root navigator key.
  static void init(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static void showInfoToast(String msg) => _show(msg, ToastType.info);

  static void showSuccessToast(String msg) => _show(msg, ToastType.success);

  static void showWarningToast(String msg) => _show(msg, ToastType.warning);

  static void showErrorToast(String msg) => _show(msg, ToastType.error);

  static void _show(String msg, ToastType type) {
    final overlay = _navigatorKey?.currentState?.overlay;
    if (overlay == null || msg.trim().isEmpty) return;

    _removeNow();
    if (type == ToastType.error) {
      HapticFeedback.lightImpact();
    }

    late final OverlayEntry entry;
    // Built once: the overlay re-invokes the entry builder on every route
    // push/pop, and a fresh widget/key there would restart the animation.
    final card = _ToastCard(
      key: GlobalKey<_ToastCardState>(),
      message: msg,
      type: type,
      duration: Duration(milliseconds: 2200 + msg.length * 20),
      onAttached: (state) => _card = state,
      onDismissed: () {
        if (_entry == entry) {
          entry.remove();
          _entry = null;
          _card = null;
        }
      },
    );
    entry = OverlayEntry(builder: (_) => card);
    _entry = entry;
    overlay.insert(entry);
  }

  static void _removeNow() {
    _entry?.remove();
    _entry = null;
    _card = null;
  }

  static void dismiss() => _card?.dismiss();
}

class _ToastStyle {
  final Color accent;
  final IconData icon;
  const _ToastStyle(this.accent, this.icon);

  static _ToastStyle of(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const _ToastStyle(Color(0xFF22C55E), Icons.check_circle_rounded);
      case ToastType.warning:
        return const _ToastStyle(Color(0xFFF59E0B), Icons.warning_rounded);
      case ToastType.error:
        return const _ToastStyle(Color(0xFFEF4444), Icons.error_rounded);
      case ToastType.info:
        return const _ToastStyle(Color(0xFF3B82F6), Icons.info_rounded);
    }
  }
}

class _ToastCard extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final void Function(_ToastCardState state) onAttached;
  final VoidCallback onDismissed;

  const _ToastCard({
    super.key,
    required this.message,
    required this.type,
    required this.duration,
    required this.onAttached,
    required this.onDismissed,
  });

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  Timer? _timer;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 220),
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );
    _slide = Tween<Offset>(begin: const Offset(0, -1.2), end: Offset.zero)
        .animate(curved);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    widget.onAttached(this);
    _controller.forward();
    _timer = Timer(widget.duration, dismiss);
  }

  Future<void> dismiss() async {
    if (_closing || !mounted) return;
    _closing = true;
    _timer?.cancel();
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final style = _ToastStyle.of(widget.type);
    final top = MediaQuery.of(context).padding.top;

    final background = isDark ? const Color(0xFF2A2A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);

    return Positioned(
      top: top + 12,
      left: 16,
      right: 16,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: Dismissible(
                key: const ValueKey('toast_dismissible'),
                direction: DismissDirection.up,
                onDismissed: (_) {
                  _timer?.cancel();
                  _closing = true;
                  widget.onDismissed();
                },
                child: GestureDetector(
                  onTap: dismiss,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: style.accent.withValues(alpha: 0.35),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.5 : 0.14),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: style.accent.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child:
                                Icon(style.icon, color: style.accent, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              widget.message,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14.5,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
