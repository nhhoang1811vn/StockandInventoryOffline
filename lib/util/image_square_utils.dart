import 'dart:typed_data';
import 'dart:ui' as ui;

/// The largest square centered in a [width] x [height] image.
({int x, int y, int side}) centerSquareRect(int width, int height) {
  final side = width < height ? width : height;
  return (x: (width - side) ~/ 2, y: (height - side) ~/ 2, side: side);
}

/// Crops [bytes] to the largest centered square and returns PNG bytes.
Future<Uint8List> centerCropSquare(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final source = frame.image;
  try {
    final rect = centerSquareRect(source.width, source.height);
    final recorder = ui.PictureRecorder();
    final side = rect.side.toDouble();
    ui.Canvas(recorder).drawImageRect(
      source,
      ui.Rect.fromLTWH(rect.x.toDouble(), rect.y.toDouble(), side, side),
      ui.Rect.fromLTWH(0, 0, side, side),
      ui.Paint(),
    );
    final picture = recorder.endRecording();
    final cropped = await picture.toImage(rect.side, rect.side);
    try {
      final data = await cropped.toByteData(format: ui.ImageByteFormat.png);
      return data!.buffer.asUint8List();
    } finally {
      cropped.dispose();
      picture.dispose();
    }
  } finally {
    source.dispose();
    codec.dispose();
  }
}
