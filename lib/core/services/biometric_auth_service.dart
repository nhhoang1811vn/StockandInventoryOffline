import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

/// Thin wrapper over `local_auth`. Never throws: any failure means "no".
@lazySingleton
class BiometricAuthService {
  final LocalAuthentication _auth;

  BiometricAuthService(this._auth);

  /// True when the device supports biometrics and at least one is enrolled.
  Future<bool> isAvailable() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      final enrolled = await _auth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Shows the biometric prompt (device PIN is not offered; the app passcode
  /// is the fallback). Returns false on failure, cancel, lockout or error.
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
