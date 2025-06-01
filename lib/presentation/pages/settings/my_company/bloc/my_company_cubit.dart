import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/domain/app_settings.dart';
import 'package:good_manager/domain/entities/my_company.dart';
import 'package:injectable/injectable.dart';

part 'my_company_cubit.freezed.dart';
part 'my_company_state.dart';



@injectable
class MyCompanyCubit extends Cubit<MyCompanyState> {
  final AppSettings appSettings;
  MyCompanyCubit({required this.appSettings})
      : super(
      MyCompanyState.initial());

  Future<void> init() async{
    final item = await appSettings.getMyCompany();
    if (item != null){
      emit(state.copyWith(
          companyName: item.companyName,
          address: item.address,
        email: item.email,
        phone: item.phone,
        taxID: item.taxId,
        bankDetails: item.bankDetails,
      ));
    }
  }
  void onSaveButtonClicked(){
    MyCompany obj = MyCompany(companyName: state.companyName, address: state.address, email: state.email, phone: state.phone, taxId: state.taxID, bankDetails: state.bankDetails);
    appSettings.setMyCompany(obj);
  }

  companyNameChanged(String value) {
    emit(state.copyWith(companyName: value));
  }
  addressChanged(String value){
    emit(state.copyWith(address: value));
  }
  emailChanged(String value){
    emit(state.copyWith(email: value));
  }

  phoneNumberChanged(String value) {
    emit(state.copyWith(phone: value));
  }

  taxIDChanged(String value) {
    emit(state.copyWith(taxID: value));
  }

  bankDetailsChanged(String value) {
    emit(state.copyWith(bankDetails: value));
  }
}
