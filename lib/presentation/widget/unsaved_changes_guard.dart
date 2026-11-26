import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../dialog/custom_dialog.dart';

/// Wraps an edit screen and asks for confirmation before the user leaves
/// with unsaved input (back button, back gesture, app bar arrow).
///
/// Dirty state is set when a form field changes after the user has touched
/// the screen, so values populated programmatically on open do not count.
/// A successful save should close the page with `Navigator.pop`, which
/// bypasses this guard by design.
class UnsavedChangesGuard extends StatefulWidget {
  final Widget child;

  const UnsavedChangesGuard({super.key, required this.child});

  @override
  State<UnsavedChangesGuard> createState() => _UnsavedChangesGuardState();
}

class _UnsavedChangesGuardState extends State<UnsavedChangesGuard> {
  bool _touched = false;
  bool _dirty = false;

  Future<void> _confirmDiscard() async {
    final navigator = Navigator.of(context);
    await showCustomAlertDialog(
      context,
      message: context.tr('unsaved_changes_message'),
      positiveText: context.tr('action_discard'),
      negativeText: context.tr('action_keep_editing'),
      destructive: true,
      onNegativePressed: () => navigator.pop(),
      onPositivePressed: () {
        navigator.pop(); // close dialog
        if (mounted) setState(() => _dirty = false);
        navigator.pop(); // leave the page
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmDiscard();
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _touched = true,
        child: Form(
          onChanged: () {
            if (_touched && !_dirty) setState(() => _dirty = true);
          },
          child: widget.child,
        ),
      ),
    );
  }
}
