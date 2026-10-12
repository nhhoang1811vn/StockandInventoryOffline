import 'package:flutter/material.dart';

class SummaryLine extends StatelessWidget {
  final List<String> parts;
  final String? caption;
  final bool filled;

  const SummaryLine(
    this.parts, {
    super.key,
    this.caption,
    this.filled = true,
  });

  static String item(String label, String value) => '$label: $value';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = [
      if (caption != null && caption!.isNotEmpty) caption!,
      parts.join(' | '),
    ].join('\n');

    final content = Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: filled ? theme.colorScheme.onPrimary : null,
          ),
        ),
      ),
    );

    if (!filled) return content;

    return ColoredBox(
      color: theme.colorScheme.primary,
      child: content,
    );
  }
}
