import 'package:flutter/material.dart';

/// Primary call-to-action. Colors and shape come from the app theme
/// (`elevatedButtonTheme`), so text stays readable on any seed color.
/// Pass [loading] to show a spinner and block repeated taps.
/// Pass [icon] for a leading icon; the label then shrinks to fit one line
/// instead of wrapping, so paired buttons keep the same height.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  const PrimaryButton(this.text, this.onPressed,
      {super.key, this.loading = false, this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (loading) {
      return ElevatedButton(
        onPressed: null,
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: scheme.onPrimary,
          ),
        ),
      );
    }
    if (icon == null) {
      return ElevatedButton(onPressed: onPressed, child: Text(text));
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text, maxLines: 1),
      ),
    );
  }
}
