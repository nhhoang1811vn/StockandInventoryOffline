class AuthInput {
  static final emailPattern = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
  );

  static const int minPasswordLength = 6;

  static bool isValidEmail(String value) => emailPattern.hasMatch(value.trim());

  static bool isValidPassword(String value) =>
      value.trim().length >= minPasswordLength;
}
