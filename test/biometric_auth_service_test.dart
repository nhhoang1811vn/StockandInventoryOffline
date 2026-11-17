import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/core/services/biometric_auth_service.dart';
import 'package:local_auth/local_auth.dart';

class _FakeLocalAuth extends LocalAuthentication {
  bool supported = true;
  List<BiometricType> enrolled = [BiometricType.fingerprint];
  bool authResult = true;
  bool throws = false;

  @override
  Future<bool> isDeviceSupported() async {
    if (throws) throw PlatformException(code: 'error');
    return supported;
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (throws) throw PlatformException(code: 'error');
    return enrolled;
  }

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Iterable<dynamic> authMessages = const [],
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    if (throws) throw PlatformException(code: 'LockedOut');
    return authResult;
  }
}

void main() {
  late _FakeLocalAuth fake;
  late BiometricAuthService service;

  setUp(() {
    fake = _FakeLocalAuth();
    service = BiometricAuthService(fake);
  });

  group('isAvailable', () {
    test('is true when supported and a biometric is enrolled', () async {
      expect(await service.isAvailable(), isTrue);
    });
    test('is false when the device is not supported', () async {
      fake.supported = false;
      expect(await service.isAvailable(), isFalse);
    });
    test('is false when nothing is enrolled', () async {
      fake.enrolled = [];
      expect(await service.isAvailable(), isFalse);
    });
    test('is false when the plugin throws', () async {
      fake.throws = true;
      expect(await service.isAvailable(), isFalse);
    });
  });

  group('authenticate', () {
    test('returns true on success', () async {
      expect(await service.authenticate('reason'), isTrue);
    });
    test('returns false when the user fails or cancels', () async {
      fake.authResult = false;
      expect(await service.authenticate('reason'), isFalse);
    });
    test('returns false when the plugin throws', () async {
      fake.throws = true;
      expect(await service.authenticate('reason'), isFalse);
    });
  });
}
