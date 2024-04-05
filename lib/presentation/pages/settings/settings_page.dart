import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/main.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../custom_navigation_drawer.dart';
import '../pages.dart';
import 'components/change_languages_dialog.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomNavigationDrawer(selectedIndex: 8, storeName: storage.getSelectedStoreName()),
        appBar: new AppBar(
            title: new Text(AppLocalizations.of(context)!.settings_title)),
        body: ListView(
          //key: globalKey,
          children: [
            ListTile(
              leading: Icon(Icons.language),
              title:
              Text(AppLocalizations.of(context)!.menu_item_language_title),
              subtitle:
              Text(AppLocalizations.of(context)!.menu_item_language_desc),
              onTap: (){ showSelectLanguageDialog(context);},
            ),
            Divider(color: Colors.grey[500]),
            ListTile(
              leading: Icon(UIConstants.barcodeIconData),
              title: Text(
                  AppLocalizations.of(context)!.menu_item_barcode_scanner_title),
              onTap: () => onBarcodeScannerPressed(context),
            ),
            Divider(color: Colors.grey[500]),
            ListTile(
              leading: Icon(Icons.backup),
              title: Text(AppLocalizations.of(context)!.menu_back_up),
              onTap: () => onBackUpPressed(context),
            ),
            Divider(color: Colors.grey[500]),
            ListTile(
              leading: Icon(Icons.restore),
              title: Text(AppLocalizations.of(context)!.menu_restore),
              onTap: () => onRestorePressed(context),
            ),

          ],
        ));
  }
  void showSelectLanguageDialog(BuildContext context) async {
    String currentCode = storage.getLanguageCode();
    showDialog(
        context: context,
        builder: (_) => ChangeLanguagesDialog(currentCode, (code) {
          storage.setLanguageCode(code);
          MyApp.setLocale(context, code);
              //appDataManager.sharedPrefsHelper.setLanguageCode(code);
              //MyApp.setLocale(getContext(), code);
            }),
        barrierDismissible: true);
  }
  void onBarcodeScannerPressed(BuildContext context){
    Navigator.of(context).pushNamed(Pages.barcode_scanner);
  }
  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
  void onBackUpPressed(BuildContext context) async{
    try{
      var documentsDirectory = await getApplicationDocumentsDirectory();
      String dbPath = join(documentsDirectory.path, "main.db");
      File source = File(dbPath);
      String? copyTo = await getDownloadPath();
      //Directory copyTo = Directory("storage/emulated/0/Download");
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (Platform.isAndroid && androidInfo.version.sdkInt > 29) {
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          //openAppSettings();
          await Permission.manageExternalStorage.request();
        }
      }else{
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }
      final dateFormat = new DateFormat('yyyy-MM-dd');
      final timeStamp = dateFormat.format(DateTime.now());
      String newPath = "${copyTo}/good_manager_backup_database_$timeStamp.db";
      await source.copy(newPath);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.backup_successful + " " +newPath),
      ));
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Back up error: $e"),
      ));
    }
  }
  void onRestorePressed(BuildContext context) async{
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, "main.db");

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File source = File(result.files.single.path!);
      await source.copy(dbPath);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.restore_successful),
      ));
    } else {
      // User canceled the picker
    }
  }
}
