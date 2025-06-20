part of 'my_company_cubit.dart';

@freezed
class MyCompanyState with _$MyCompanyState {
  const factory MyCompanyState.initial({
    @Default("") String companyName,
    @Default("") String address,
    @Default("") String email,
    @Default("") String phone,
    @Default("") String taxID,
    @Default("") String bankDetails,

  }) = _Initial;
}