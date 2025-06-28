import 'package:freezed_annotation/freezed_annotation.dart';

part 'payments_setting.freezed.dart';
part 'payments_setting.g.dart';

@freezed
class PaymentsSetting with _$PaymentsSetting {
  factory PaymentsSetting(
      {
        required bool sortByDateNewestFirst,
        required Set<int?> selectedCategoryIds,
        required Set<int> selectedWalletIds,
        required Set<int> selectedCustomerIds,
        required Set<int> selectedSupplierIds,
        required DateTime? startDate,
        required DateTime? endDate,
      }) = _PaymentsSetting;

  factory PaymentsSetting.fromJson(Map<String, Object?> json) =>
      _$PaymentsSettingFromJson(json);

  factory PaymentsSetting.getDefault() => PaymentsSetting(
      sortByDateNewestFirst: true,
      selectedCategoryIds: {},
      selectedWalletIds : {},
      selectedCustomerIds: {},
      selectedSupplierIds: {},
      startDate: null,
      endDate: null
  );
}
