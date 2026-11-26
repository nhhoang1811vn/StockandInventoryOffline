import 'package:flutter/material.dart';

/// Shown instead of the red error box when stored image bytes cannot be
/// decoded. Use as `Image.memory(bytes, errorBuilder: brokenImageBuilder)`.
Widget brokenImageBuilder(
    BuildContext context, Object error, StackTrace? stackTrace) {
  final scheme = Theme.of(context).colorScheme;
  return ColoredBox(
    color: scheme.surfaceContainerHighest,
    child: Center(
      child: Icon(Icons.broken_image_outlined,
          color: scheme.onSurfaceVariant, semanticLabel: ''),
    ),
  );
}
