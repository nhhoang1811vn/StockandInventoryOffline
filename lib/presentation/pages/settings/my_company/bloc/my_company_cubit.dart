import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/app_settings.dart';
import '../../../../../domain/entity/entity.dart';

part 'my_company_cubit.freezed.dart';
part 'my_company_state.dart';

@injectable
class MyCompanyCubit extends Cubit<MyCompanyState> {
  MyCompanyCubit() : super(MyCompanyState.initial());

  Future<void> init() async {
    final item = await AppSettings.getMyCompany();
    emit(
      state.copyWith(
        companyName: item.companyName,
        address: item.address,
        email: item.email,
        phone: item.phone,
        taxID: item.taxId,
        bankDetails: item.bankDetails,
      ),
    );
  }

  void onSaveButtonClicked() {
    MyCompany obj = MyCompany(
      companyName: state.companyName,
      address: state.address,
      email: state.email,
      phone: state.phone,
      taxId: state.taxID,
      bankDetails: state.bankDetails,
    );
    AppSettings.setMyCompany(obj);
  }

  void companyNameChanged(String value) {
    emit(state.copyWith(companyName: value));
  }

  void addressChanged(String value) {
    emit(state.copyWith(address: value));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void phoneNumberChanged(String value) {
    emit(state.copyWith(phone: value));
  }

  void taxIDChanged(String value) {
    emit(state.copyWith(taxID: value));
  }

  void bankDetailsChanged(String value) {
    emit(state.copyWith(bankDetails: value));
  }
}
