import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:good_manager/common/platform_support.dart';

/// Scales [bytes] down to at most [size] x [size] (never up) as JPEG.
Future<Uint8List> compressImageBytes(
  Uint8List bytes, {
  required int size,
}) async {
  // flutter_image_compress has no desktop implementation.
  if (!isMobilePlatform) return bytes;
  return FlutterImageCompress.compressWithList(
    bytes,
    minHeight: size,
    minWidth: size,
    quality: 80,
  );
}
