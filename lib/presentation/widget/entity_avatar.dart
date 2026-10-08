import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../util/base64_utils.dart';

class EntityAvatar extends StatelessWidget {
  final String? file;
  final String name;
  final IconData? fallbackIcon;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const EntityAvatar({
    super.key,
    this.file,
    required this.name,
    this.fallbackIcon,
    this.radius = 20,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primaryContainer;
    final fg = foregroundColor ?? theme.colorScheme.onPrimaryContainer;
    final Uint8List? bytes = tryDecodeBase64(file);

    if (bytes != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        backgroundImage: MemoryImage(bytes),
      );
    }

    if (fallbackIcon != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: Icon(fallbackIcon, color: fg, size: radius),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.9,
        ),
      ),
    );
  }
}

class EntityPhotoAvatar extends StatelessWidget {
  final Uint8List? imageBytes;
  final IconData fallbackIcon;
  final bool canEdit;
  final VoidCallback? onTap;

  const EntityPhotoAvatar({
    super.key,
    this.imageBytes,
    required this.fallbackIcon,
    this.canEdit = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: imageBytes == null
                  ? Icon(
                      fallbackIcon,
                      size: 60,
                      color: theme.colorScheme.primary,
                    )
                  : Image.memory(
                      imageBytes!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          if (canEdit)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 20,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
