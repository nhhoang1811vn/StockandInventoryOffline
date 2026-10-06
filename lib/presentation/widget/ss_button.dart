import 'package:flutter/material.dart';

class SSButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool hasBadge;
  final Color? iconColor;
  final double iconSize;
  final Color? backgroundColor;
  final double borderRadius;
  final double padding;
  final List<BoxShadow>? boxShadow;

  const SSButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.hasBadge = false,
    this.iconColor,
    this.iconSize = 24,
    this.backgroundColor,
    this.borderRadius = 16,
    this.padding = 12,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = iconColor ?? theme.colorScheme.onSurface;

    return IconButton(
      onPressed: onPressed,
      color: fg,
      iconSize: iconSize,
      icon: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(icon, color: fg, size: iconSize),
          if (hasBadge)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
