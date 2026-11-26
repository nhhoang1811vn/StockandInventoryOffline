import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../constant/app_tokens.dart';

/// Top row of Home: the selected Store (logo, name, switch icon) with the
/// PREMIUM tag under the name for Pro users. Tapping any part switches Store.
class HomeStoreHeader extends StatelessWidget {
  final String storeName;
  final Uint8List? logoBytes;
  final bool isPro;
  final String premiumLabel;
  final VoidCallback onTap;

  const HomeStoreHeader({
    super.key,
    required this.storeName,
    required this.logoBytes,
    required this.isPro,
    required this.premiumLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The tap area hugs the logo and name; the rest of the row is not tappable.
    return Row(
      children: [
        Flexible(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: theme.colorScheme.primary,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: context.appCardColor,
                    backgroundImage:
                        logoBytes != null ? MemoryImage(logoBytes!) : null,
                    child: logoBytes == null
                        ? Icon(
                            Icons.store_rounded,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              storeName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.unfold_more_rounded,
                            key: const Key('home_store_switch_icon'),
                            size: 22,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                      if (isPro) ...[
                        const SizedBox(height: 4),
                        _PremiumBadge(label: premiumLabel),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  final String label;

  const _PremiumBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
