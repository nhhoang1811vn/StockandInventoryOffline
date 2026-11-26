import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Flags and rules for the "Stock Inventory Online" announcement popup.
/// The keys differ from the old v2.0.0 popup so it can be shown again.
class OnlineAppPromo {
  OnlineAppPromo._();

  static const String skippedKey = 'online_app_promo_skipped';
  static const String showCountKey = 'online_app_promo_show_count';
  static const int maxShows = 3;

  /// True when the popup should open now. Counts the showing, so it appears
  /// at most [maxShows] times unless the user skips it earlier.
  static Future<bool> shouldShowPopup(SharedPreferences prefs) async {
    if (prefs.getBool(skippedKey) ?? false) return false;
    final shown = prefs.getInt(showCountKey) ?? 0;
    if (shown >= maxShows) return false;
    await prefs.setInt(showCountKey, shown + 1);
    return true;
  }

  static Future<void> skipPopup(SharedPreferences prefs) =>
      prefs.setBool(skippedKey, true);
}

/// Home card promoting the Online app. One action: download it. Tapping the
/// card elsewhere opens the details popup.
class HomeOnlineAppCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String downloadLabel;
  final String hint;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const HomeOnlineAppCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.downloadLabel,
    required this.hint,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;
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
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.rocket_launch,
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
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FilledButton(
                      key: const Key('online_app_download'),
                      onPressed: onDownload,
                      child: Text(downloadLabel),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hint,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens the announcement popup. "Skip" stops it from showing again.
Future<void> showOnlineAppDialog(BuildContext context) {
  final theme = Theme.of(context);
  Widget feature(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
          ],
        ),
      );

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      title: Text(dialogContext.tr("whats_new_v2_title")),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dialogContext.tr("whats_new_v2_heading"),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            feature(Icons.cloud, dialogContext.tr("v2_feature_online_mode")),
            feature(Icons.sync, dialogContext.tr("v2_feature_realtime")),
            feature(Icons.share, dialogContext.tr("v2_feature_sharing")),
            feature(
                Icons.manage_accounts, dialogContext.tr("v2_feature_roles")),
            feature(Icons.people, dialogContext.tr("v2_feature_multiuser")),
            feature(
                Icons.flash_on, dialogContext.tr("v2_feature_performance")),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await OnlineAppPromo.skipPopup(prefs);
            if (dialogContext.mounted) Navigator.pop(dialogContext);
          },
          child: Text(
            dialogContext.tr("skip"),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(dialogContext.tr("ok")),
        ),
      ],
    ),
  );
}
