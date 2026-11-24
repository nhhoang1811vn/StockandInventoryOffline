/// Thrown when the Store's "Allow negative quantity in stock" switch is off and
/// a transaction change (add, edit or delete) would leave a Good with negative
/// stock. [available] is the stock of the Good before the change.
class InsufficientStockException implements Exception {
  final int goodId;
  final String? goodName;
  final double available;

  InsufficientStockException({
    required this.goodId,
    this.goodName,
    required this.available,
  });

  @override
  String toString() =>
      'InsufficientStockException(good $goodId, available $available)';
}
