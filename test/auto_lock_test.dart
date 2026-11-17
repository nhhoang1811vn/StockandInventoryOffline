import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/core/services/app_lock_rules.dart';
import 'package:good_manager/data/app_settings.dart';

void main() {
  group('clampAutoLockMinutes', () {
    test('raises 0 to 1', () => expect(AppSettings.clampAutoLockMinutes(0), 1));
    test('lowers 99999 to 1440',
        () => expect(AppSettings.clampAutoLockMinutes(99999), 1440));
    test('keeps 30', () => expect(AppSettings.clampAutoLockMinutes(30), 30));
  });

  group('parseAutoLockMinutes', () {
    test('accepts the boundaries', () {
      expect(AppSettings.parseAutoLockMinutes('1'), 1);
      expect(AppSettings.parseAutoLockMinutes(' 1440 '), 1440);
    });
    test('rejects out-of-range, empty, null and non-integer input', () {
      for (final input in ['0', '1441', '', null, 'abc', '5.5', '-3']) {
        expect(AppSettings.parseAutoLockMinutes(input), isNull,
            reason: '$input');
      }
    });
  });

  group('shouldAutoLock', () {
    final last = DateTime(2026, 1, 1, 10, 0, 0);
    bool run({
      Duration elapsed = const Duration(minutes: 31),
      bool passcodeOn = true,
      bool lockOpen = false,
      int minutes = 30,
    }) =>
        shouldAutoLock(
          passcodeOn: passcodeOn,
          lockOpen: lockOpen,
          lastActivity: last,
          now: last.add(elapsed),
          minutes: minutes,
        );

    test('is true at exactly N minutes', () {
      expect(run(elapsed: const Duration(minutes: 30)), isTrue);
    });
    test('is true after N minutes', () => expect(run(), isTrue));
    test('is false one second before N minutes', () {
      expect(run(elapsed: const Duration(minutes: 29, seconds: 59)), isFalse);
    });
    test('is false when passcode is off', () {
      expect(run(passcodeOn: false), isFalse);
    });
    test('is false when a lock is already open', () {
      expect(run(lockOpen: true), isFalse);
    });
  });
}
