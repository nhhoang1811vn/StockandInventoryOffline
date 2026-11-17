import 'package:flutter/widgets.dart';

/// Rebuilds [child] with a fresh [State] whenever [itemCount] decreases.
///
/// `StickyGroupedListView` keeps an internal "top element index" that is never
/// reset. When the list shrinks (delete / filter), the stale index points past
/// the end of the list and throws `RangeError` / `Bad state: No element`
/// (Crashlytics). Recreating the list on shrink resets that index.
class ResetOnShrink extends StatefulWidget {
  const ResetOnShrink({
    super.key,
    required this.itemCount,
    required this.child,
  });

  final int itemCount;
  final Widget child;

  @override
  State<ResetOnShrink> createState() => _ResetOnShrinkState();
}

class _ResetOnShrinkState extends State<ResetOnShrink> {
  int _version = 0;

  @override
  void didUpdateWidget(ResetOnShrink oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount < oldWidget.itemCount) _version++;
  }

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: ValueKey(_version), child: widget.child);
}
