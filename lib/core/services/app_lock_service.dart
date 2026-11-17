import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:injectable/injectable.dart';

import '../../data/app_settings.dart';
import 'app_lock_rules.dart';
import 'biometric_auth_service.dart';

/// Owns the lock screen (cold start and auto-lock after inactivity).
///
/// `attach` gives it the app's navigator; `start` (called by `MainPage`)
/// begins the idle check, so nothing locks before the main page exists.
@lazySingleton
class AppLockService {
  final BiometricAuthService _biometric;

  AppLockService(this._biometric);

  GlobalKey<NavigatorState>? _navigatorKey;
  DateTime _lastActivity = DateTime.now();
  bool _lockOpen = false;
  bool _started = false;

  void attach(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  /// Idempotent. Starts the periodic idle check (lives as long as the app).
  void start() {
    if (_started) return;
    _started = true;
    _lastActivity = DateTime.now();
    Timer.periodic(const Duration(seconds: 10), (_) => _check());
  }

  /// Called on every pointer event; must stay cheap.
  void markActivity() {
    _lastActivity = DateTime.now();
  }

  void onLifecycleChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  void _check() {
    if (!_started) return;
    final lock = shouldAutoLock(
      passcodeOn: AppSettings.getEnablePasscode(),
      lockOpen: _lockOpen,
      lastActivity: _lastActivity,
      now: DateTime.now(),
      minutes: AppSettings.getAutoLockMinutes(),
    );
    if (lock) showLock();
  }

  /// Shows the passcode lock screen (with fingerprint when enabled). No-op if
  /// passcode lock is off, a lock is already open, or no navigator is ready.
  void showLock() {
    if (!AppSettings.getEnablePasscode() || _lockOpen) return;
    // The overlay's context sits below the Navigator, so Navigator.of works.
    final context = _navigatorKey?.currentState?.overlay?.context;
    if (context == null) return;

    final useFingerprint = AppSettings.getEnableFingerprint();
    _lockOpen = true;
    screenLock(
      context: context,
      onValidate: (enteredCode) async {
        final storedCode = AppSettings.getPasscode();
        return enteredCode == storedCode;
      },
      correctString: AppSettings.getPasscode(),
      onUnlocked: _unlocked,
      onOpened: useFingerprint ? _unlockWithFingerprint : null,
      customizedButtonChild:
          useFingerprint ? const Icon(Icons.fingerprint) : null,
      customizedButtonTap: useFingerprint ? _unlockWithFingerprint : null,
      canCancel: false,
      title: Text(context.tr("enter_pin_to_unlock")),
    );
  }

  void _unlocked() {
    if (!_lockOpen) return;
    _lockOpen = false;
    _lastActivity = DateTime.now();
    _navigatorKey?.currentState?.pop();
  }

  /// Passcode stays usable: a failed or cancelled scan does nothing.
  Future<void> _unlockWithFingerprint() async {
    final context = _navigatorKey?.currentState?.overlay?.context;
    if (context == null) return;
    final ok =
        await _biometric.authenticate(context.tr("fingerprint_unlock_reason"));
    if (ok) _unlocked();
  }
}
