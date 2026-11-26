import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constant/app_tokens.dart';

/// Building blocks shared by every filter bottom sheet so they all look and
/// behave the same: header with close button, section titles, choice chips
/// and the Reset / Apply row.

class FilterSheetHeader extends StatelessWidget {
  const FilterSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            context.tr('title_filter'),
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        IconButton(
          tooltip: context.tr('a11y_close'),
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class FilterSectionTitle extends StatelessWidget {
  final String text;

  const FilterSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: AppType.caption,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class FilterChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? icon;

  const FilterChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? scheme.onPrimary : scheme.onSurface;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? scheme.primary : scheme.surface,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          borderRadius: AppRadius.mdAll,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              borderRadius: AppRadius.mdAll,
              border: Border.all(
                color: selected
                    ? scheme.primary
                    : scheme.onSurface.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: AppSpacing.xs),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: fg,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                      fontSize: AppType.body,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Wraps chips with the shared spacing.
class FilterChipWrap extends StatelessWidget {
  final List<Widget> children;

  const FilterChipWrap({super.key, required this.children});

  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: 10, runSpacing: 10, children: children);
}

class FilterSheetActions extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  const FilterSheetActions(
      {super.key, required this.onReset, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onReset,
              child: Text(context.tr('action_reset_all')),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: ElevatedButton(
              onPressed: onApply,
              child: Text(context.tr('action_apply')),
            ),
          ),
        ],
      ),
    );
  }
}
