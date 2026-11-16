import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:good_manager/common/platform_support.dart';

Future<Uint8List> compressImageBytes(Uint8List bytes) async {
  // flutter_image_compress has no desktop implementation.
  if (!isMobilePlatform) return bytes;
  return FlutterImageCompress.compressWithList(
    bytes,
    minHeight: 500,
    minWidth: 500,
    quality: 80,
  );
}
