/// Thrown when the Store's "Unique barcode" rule is on and another Good of the
/// same Store already uses [barcode].
class DuplicateBarcodeException implements Exception {
  final String barcode;

  DuplicateBarcodeException(this.barcode);

  @override
  String toString() => 'DuplicateBarcodeException($barcode)';
}

/// Thrown when the Store's "Unique group" rule is on and another Group of the
/// same Store already has [name].
class DuplicateGroupNameException implements Exception {
  final String name;

  DuplicateGroupNameException(this.name);

  @override
  String toString() => 'DuplicateGroupNameException($name)';
}
