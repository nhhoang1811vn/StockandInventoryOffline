import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/minimum_quantity_settings.dart';
import 'package:good_manager/domain/entities/my_company.dart';
import 'package:injectable/injectable.dart';

import '../common/storage2.dart';
import '../domain/app_settings.dart';

@Injectable(as: AppSettings)
class AppSettingsImpl implements AppSettings {

  final Storage2 storage;
  AppSettingsImpl(this.storage);

  static const _myCompanyKey = 'my_company';
  static const _minimumQuantitySettingsKey = 'minimumQuantitySettings';

  @override
  Future<MyCompany?> getMyCompany() async{
    final jsonString = await storage.read(_myCompanyKey);
    if (jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString);
    return MyCompany.fromJson(jsonMap);
  }

  @override
  Future<void> setMyCompany(MyCompany obj) async{
    final jsonString = jsonEncode(obj.toJson());
    await storage.write(_myCompanyKey, jsonString);
  }

  @override
  Future<MinimumQuantitySettings> getMinimumQuantitySettings() async{
    final jsonString = await storage.read(_minimumQuantitySettingsKey);
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
  Future<void> setMinimumQuantitySettings(MinimumQuantitySettings obj) async{
    final jsonString = jsonEncode(obj.toJson());
    await storage.write(_minimumQuantitySettingsKey, jsonString);
  }
}