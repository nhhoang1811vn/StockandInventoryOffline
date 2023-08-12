import 'package:flutter/material.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/style_size.dart';

class AppStyle{
  static getTitleListTitleStyle(){
    return TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: TextSize.large);
  }
  static getSubTitleListTitleStyle(){
    return TextStyle(fontSize: TextSize.medium);
  }
  static getTrailingListTitleStyle(){
    return TextStyle(fontSize: TextSize.large);
  }

  static getHomeMenuTitleStyle(){
    return TextStyle(color: AppColors.primaryColor, fontSize: TextSize.large);
  }

  static getEmptyTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: TextSize.large,
    );
  }
}