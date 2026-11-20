import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/presentation/pages/report/report_years.dart';

void main() {
  test('five most recent years, newest first', () {
    expect(recentYears(DateTime(2026, 11, 20)), [2026, 2025, 2024, 2023, 2022]);
  });

  test('stable on 1 Jan and 31 Dec', () {
    expect(recentYears(DateTime(2026, 1, 1)).first, 2026);
    expect(recentYears(DateTime(2026, 1, 1)).length, 5);
    expect(recentYears(DateTime(2026, 12, 31, 23, 59)).first, 2026);
    expect(recentYears(DateTime(2026, 12, 31, 23, 59)).length, 5);
  });

  test('count parameter', () {
    expect(recentYears(DateTime(2026, 6, 1), count: 3), [2026, 2025, 2024]);
  });
}
