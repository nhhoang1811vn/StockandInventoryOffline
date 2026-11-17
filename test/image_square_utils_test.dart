import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/util/image_square_utils.dart';

void main() {
  group('centerSquareRect', () {
    test('landscape is cropped horizontally around the center', () {
      final r = centerSquareRect(1000, 600);
      expect((r.x, r.y, r.side), (200, 0, 600));
    });
    test('portrait is cropped vertically around the center', () {
      final r = centerSquareRect(600, 1000);
      expect((r.x, r.y, r.side), (0, 200, 600));
    });
    test('square image is returned whole', () {
      final r = centerSquareRect(500, 500);
      expect((r.x, r.y, r.side), (0, 0, 500));
    });
    test('very wide panorama keeps the middle slice', () {
      final r = centerSquareRect(4000, 100);
      expect((r.x, r.y, r.side), (1950, 0, 100));
    });
    test('odd size difference floors the offset', () {
      final r = centerSquareRect(101, 50);
      expect((r.x, r.y, r.side), (25, 0, 50));
    });
  });
}
