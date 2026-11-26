import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/widget/broken_image.dart';
import 'package:good_manager/util/entity_image_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../pages/full_image_page.dart';
import 'circle_button_widget.dart';

class ImagesInformationSection extends StatelessWidget {
  final List<Uint8List> files;
  final bool canEdit;
  final void Function(Uint8List bytes) onAddFile;
  final void Function(int index) onDeleteFile;

  const ImagesInformationSection({
    super.key,
    required this.files,
    required this.canEdit,
    required this.onAddFile,
    required this.onDeleteFile,
  });

  Future<void> _showImageSourceDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text(context.tr("choose_gallery")),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndAdd(context, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(context.tr("take_picture")),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndAdd(context, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndAdd(BuildContext context, ImageSource source) async {
    final bytes = await EntityImagePicker.pickSquareImage(source);
    if (bytes != null) {
      onAddFile(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              context.tr("images_information"),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (files.isNotEmpty && canEdit)
              CircleButton(Icons.add_a_photo, () {
                _showImageSourceDialog(context);
              }),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.outline, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: files.isEmpty
              ? _buildAddPhotoWidget(context)
              : _buildPreview(context),
        ),
      ],
    );
  }

  Widget _buildAddPhotoWidget(BuildContext context) {
    return GestureDetector(
      onTap: canEdit ? () => _showImageSourceDialog(context) : null,
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 40),
            const SizedBox(height: 8),
            Text(
              context.tr("tap_to_add_file"),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      children: files.asMap().entries.map((entry) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullImagePage(
                      base64Image: base64Encode(entry.value),
                      heroTag: 'imageHero_${entry.key}',
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  entry.value,
                  width: 100,
                  height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: brokenImageBuilder),
              ),
            ),
            if (canEdit)
              Positioned(
                right: 4,
                top: 4,
                child: GestureDetector(
                  onTap: () => onDeleteFile(entry.key),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}
