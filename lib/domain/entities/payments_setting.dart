import 'package:freezed_annotation/freezed_annotation.dart';

part 'payments_setting.freezed.dart';
part 'payments_setting.g.dart';

@freezed
class PaymentsSetting with _$PaymentsSetting {
  factory PaymentsSetting(
      {
        required int? selectedCategoryId,
        required int? selectedWalletId,

        required DateTime? startDate,
        required DateTime? endDate,
      }) = _PaymentsSetting;

  factory PaymentsSetting.fromJson(Map<String, Object?> json) =>
      _$PaymentsSettingFromJson(json);

  factory PaymentsSetting.getDefault() => PaymentsSetting(
      selectedCategoryId : null,
      selectedWalletId : null,
      startDate: null,
      endDate: null
  );
}
