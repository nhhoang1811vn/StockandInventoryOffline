import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_manager/presentation/widget/broken_image.dart';

class FullImagePage extends StatelessWidget {
  final String base64Image;
  final String heroTag;

  const FullImagePage({
    super.key,
    required this.base64Image,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Hero(
            tag: heroTag,
            child: InteractiveViewer(
                child: Image.memory(base64Decode(base64Image),
                    errorBuilder: brokenImageBuilder)),
          ),
        ),
      ),
    );
  }
}
