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
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;
    // Same card language as the settings and wallet cards: card surface,
    // 22px corners, soft shadow; the accent only tints the icon and buttons.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        key: const Key('windows_banner_card'),
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.desktop_windows_rounded,
                        color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            message,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
      ),
    );
  }
}
