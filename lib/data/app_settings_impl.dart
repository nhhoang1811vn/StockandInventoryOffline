import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_manager/data/utils/constants.dart';
import 'package:good_manager/domain/entities/minimum_quantity_settings.dart';
import 'package:good_manager/domain/entities/my_company.dart';
import 'package:good_manager/domain/entities/payments_setting.dart';
import 'package:good_manager/domain/entities/save_document_setting.dart';
import 'package:good_manager/domain/entities/stores_setting.dart';
import 'package:injectable/injectable.dart';

import '../common/storage2.dart';
import '../domain/app_settings.dart';
import '../domain/entities/customers_setting.dart';
import '../domain/entities/documents_setting.dart';
import '../domain/entities/goods_setting.dart';
import '../domain/entities/suppliers_setting.dart';

@Injectable(as: AppSettings)
class AppSettingsImpl implements AppSettings {

  final Storage2 storage;
  AppSettingsImpl(this.storage);

  static const _myCompanyKey = 'my_company';
  static const _minimumQuantitySettingsKey = 'minimumQuantitySettings';
  static const _suppliersSettingKey = "SuppliersSetting";
  static const _customersSettingKey = "CustomersSetting";
  static const _goodsSettingKey = "GoodsSetting";
  static const _documentsSettingKey = "DocumentsSetting3";
  static const _storesSettingKey = "StoresSetting";
  static const String _saveDocumentSettingKey = "SaveDocumentSetting";
  static const String _PaymentsSettingKey = "PaymentsSetting5";

  static const String _incomingDocumentColorKey = "_incomingDocumentColorKey";
  static const String _outgoingDocumentColorKey = "_outgoingDocumentColorKey";

  //int incomingDocumentColorDefault = Colors.red.value;
  //int _

  @override
  MyCompany getMyCompany(){
    final jsonString = storage.read(_myCompanyKey);
    if (jsonString == null) return MyCompany(companyName: "", address: "", email: "", phone: "", taxId: "", bankDetails: "");
    final jsonMap = jsonDecode(jsonString);
    return MyCompany.fromJson(jsonMap);
  }

  @override
  void setMyCompany(MyCompany obj){
    final jsonString = jsonEncode(obj.toJson());
    storage.write(_myCompanyKey, jsonString);
  }

  @override
  MinimumQuantitySettings getMinimumQuantitySettings(){
    final jsonString = storage.read(_minimumQuantitySettingsKey);
    if (jsonString == null) return MinimumQuantitySettings(
        showInList: true,
        showInItem: true,
        color: Colors.red.value,
        showAlert: true
    );
    final jsonMap = jsonDecode(jsonString);
    return MinimumQuantitySettings.fromJson(jsonMap);
  }

  @override
  void setMinimumQuantitySettings(MinimumQuantitySettings obj){
    final jsonString = jsonEncode(obj.toJson());
    storage.write(_minimumQuantitySettingsKey, jsonString);
  }

  @override
  SuppliersSetting getSuppliersSetting() {
    final jsonString = storage.read(_suppliersSettingKey);
    if (jsonString == null)
      return SuppliersSetting.getDefault();
    return SuppliersSetting.fromJson(jsonDecode(jsonString));
  }
  @override
  void setSuppliersSetting(SuppliersSetting obj) {
    storage.write(_suppliersSettingKey, jsonEncode(obj.toJson()));
  }

  @override
  CustomersSetting getCustomersSetting() {
    final jsonString = storage.read(_customersSettingKey);
    if (jsonString == null)
      return CustomersSetting.getDefault();
    return CustomersSetting.fromJson(jsonDecode(jsonString));
  }
  @override
  void setCustomersSetting(CustomersSetting obj) {
    storage.write(_customersSettingKey, jsonEncode(obj.toJson()));
  }

  @override
  GoodsSetting getGoodsSetting() {
    final jsonString = storage.read(_goodsSettingKey);
    if (jsonString == null)
      return GoodsSetting.getDefault();
    return GoodsSetting.fromJson(jsonDecode(jsonString));
  }
  @override
  void setGoodsSetting(GoodsSetting obj) {
    storage.write(_goodsSettingKey, jsonEncode(obj.toJson()));
  }

  @override
  DocumentsSetting getDocumentsSetting() {
    final jsonString = storage.read(_documentsSettingKey);
    if (jsonString == null)
      return DocumentsSetting.getDefault();
    return DocumentsSetting.fromJson(jsonDecode(jsonString));
  }
  @override
  void setDocumentsSetting(DocumentsSetting obj) {
    storage.write(_documentsSettingKey, jsonEncode(obj.toJson()));
  }

  @override
  StoresSetting getStoresSetting() {
    final jsonString = storage.read(_storesSettingKey);
    if (jsonString == null)
      return StoresSetting.getDefault();
    return StoresSetting.fromJson(jsonDecode(jsonString));
  }

  @override
  void setStoresSetting(StoresSetting obj) {
    storage.write(_storesSettingKey, jsonEncode(obj.toJson()));
  }

  @override
  SaveDocumentSetting getSaveDocumentSetting() {
    final jsonString = storage.read(_saveDocumentSettingKey);
    if (jsonString == null)
      return SaveDocumentSetting.getDefault();
    return SaveDocumentSetting.fromJson(jsonDecode(jsonString));
  }

  @override
  void setSaveDocumentSetting(SaveDocumentSetting obj) {
    storage.write(_saveDocumentSettingKey, jsonEncode(obj.toJson()));
  }

  @override
  PaymentsSetting getPaymentsSetting() {
    final jsonString = storage.read(_PaymentsSettingKey);
    if (jsonString == null)
      return PaymentsSetting.getDefault();
    return PaymentsSetting.fromJson(jsonDecode(jsonString));
  }

  @override
  void setPaymentsSetting(PaymentsSetting obj) {
    storage.write(_PaymentsSettingKey, jsonEncode(obj.toJson()));
  }
  
  @override
  Color getIncomingDocumentColor() {
    return Color(storage.readInt(_incomingDocumentColorKey, Constants.incomingDocumentColor.value));
  }
  @override
  void setIncomingDocumentColor(Color color) {
    storage.writeInt(_incomingDocumentColorKey, color.value);
  }

  @override
  Color getOutgoingDocumentColor() {
    return Color(storage.readInt(_outgoingDocumentColorKey, Constants.outgoingDocumentColor.value));
  }
  @override
  void setOutgoingDocumentColor(Color color) {
    storage.writeInt(_outgoingDocumentColorKey, color.value);
  }


  @override
  int? getSavePaymentLastSelectedWalletId() {
    var result = storage.readInt("SavePaymentLastSelectedWalletId", -1);
    if (result == -1){
      return null;
    }
    return result;
  }
  @override
  void setSavePaymentLastSelectedWalletId(int? walletId) {
    if (walletId != null){
      storage.writeInt("SavePaymentLastSelectedWalletId", walletId);
    }
  }
}