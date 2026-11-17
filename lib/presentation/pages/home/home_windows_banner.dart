import 'package:flutter/material.dart';

/// Home banner announcing the Windows version. Texts are passed in so the
/// widget stays free of localization and is easy to test.
class HomeWindowsBanner extends StatelessWidget {
  final String title;
  final String message;
  final String downloadLabel;
  final String guideLabel;
  final VoidCallback onDownload;
  final VoidCallback onGuide;

  const HomeWindowsBanner({
    super.key,
    required this.title,
    required this.message,
    required this.downloadLabel,
    required this.guideLabel,
    required this.onDownload,
    required this.onGuide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.desktop_windows_rounded,
                    color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(message, style: theme.textTheme.bodySmall),
            ),
            const SizedBox(height: 4),
            Wrap(
              children: [
                TextButton.icon(
                  key: const Key('windows_banner_download'),
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: Text(downloadLabel),
                  onPressed: onDownload,
                ),
                TextButton.icon(
                  key: const Key('windows_banner_guide'),
                  icon: const Icon(Icons.menu_book_rounded, size: 18),
                  label: Text(guideLabel),
                  onPressed: onGuide,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
