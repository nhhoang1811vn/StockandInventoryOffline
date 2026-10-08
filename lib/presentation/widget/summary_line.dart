import 'package:flutter/material.dart';

class SummaryLine extends StatelessWidget {
  final List<String> parts;
  final String? caption;

  const SummaryLine(
    this.parts, {
    super.key,
    this.caption,
  });

  static String item(String label, String value) => '$label: $value';

  @override
  Widget build(BuildContext context) {
    final text = [
      if (caption != null && caption!.isNotEmpty) caption!,
      parts.join(' | '),
    ].join('\n');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                height: 1.2,
              ),
        ),
      ),
    );
  }
}
