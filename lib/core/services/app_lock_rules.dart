/// True when the app must be locked again: passcode is on, no
/// lock screen is open, and the idle time reached [minutes].
bool shouldAutoLock({
  required bool passcodeOn,
  required bool lockOpen,
  required DateTime lastActivity,
  required DateTime now,
  required int minutes,
}) {
  if (!passcodeOn || lockOpen) return false;
  return now.difference(lastActivity) >= Duration(minutes: minutes);
}
