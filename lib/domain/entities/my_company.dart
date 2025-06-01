import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_company.freezed.dart';
part 'my_company.g.dart';

@freezed
class MyCompany with _$MyCompany {
  factory MyCompany({
    required String companyName,
    required String address,
    required String email,
    required String phone,
    required String taxId,
    required String bankDetails,
  }) = _MyCompany;

  factory MyCompany.fromJson(Map<String, dynamic> json) =>
      _$MyCompanyFromJson(json);
}