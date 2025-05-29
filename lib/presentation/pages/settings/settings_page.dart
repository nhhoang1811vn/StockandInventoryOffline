import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/common/path_utils.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/widgets/snackbar_widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../pages.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  var cloudFileUpdatedTime = "";
  @override
  void initState() {
    super.initState();
    loadCloudFileUpdatedTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: new Text(AppLocalizations.of(context)!.settings_title)),
        body: _buildBody(),
      );
  }


  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                    AppLocalizations.of(context)!.menu_item_general),
                onTap: () {
                  Navigator.of(context).pushNamed(Pages.settings_general);
                  //showSelectLanguageDialog(context);
                },
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.visibility),
                title: Text(
                    AppLocalizations.of(context)!.menu_item_view),
                onTap: () {
                  Navigator.of(context).pushNamed(Pages.settings_view);
                },
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(UIConstants.barcodeIconData),
                title: Text(AppLocalizations.of(context)!
                    .menu_item_barcode_scanner),
                onTap: () => onBarcodeScannerPressed(context),
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.warning),
                title: Text(AppLocalizations.of(context)!
                    .menu_item_minimum_quantity),
                //onTap: () => onBarcodeScannerPressed(context),
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.business),
                title: Text(AppLocalizations.of(context)!
                    .menu_item_my_store),
                //onTap: () => onBarcodeScannerPressed(context),
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.backup),
                title: Text(AppLocalizations.of(context)!
                    .menu_item_backup_and_restore),
                //onTap: () => onBarcodeScannerPressed(context),
                trailing: Icon(Icons.navigate_next),
              ),
              SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 8,
        ),
        Card(

          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              ListTile(
                leading: Icon(Icons.backup),
                title: Text(AppLocalizations.of(context)!.menu_back_up),
                subtitle: Text(AppLocalizations.of(context)!.menu_back_up_desc),
                onTap: () => onBackUpPressed(context),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.restore),
                title: Text(AppLocalizations.of(context)!.menu_restore),
                subtitle: Text(AppLocalizations.of(context)!.menu_restore_desc),
                onTap: () => onRestorePressed(context),
              ),
              Divider(
                height: 1,
              ),
              //Divider(color: Colors.grey[500]),
              ListTile(
                leading: Icon(Icons.cloud),
                title:
                    Text(AppLocalizations.of(context)!.menu_push_data_to_cloud),
                subtitle: cloudFileUpdatedTime.isEmpty
                    ? Text(AppLocalizations.of(context)!.cloud_file_no_updated)
                    : Text(cloudFileUpdatedTime),
                onTap: () => onCloudPressed(context),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.sync),
                title: Text("Quick Sync"),
                subtitle: Text(
                    "It will restart the app, and sync the latest app data"),
                onTap: () => onQuickSyncPressed(context),
              ),
              SizedBox(
                height: 4,
              ),
            ],
          ),
        )
      ],
    );
  }

  void loadCloudFileUpdatedTime() async {
    final storageRef = FirebaseStorage.instance.ref();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final ref = storageRef.child("$uid/database.db");
        final metadata = await ref.getMetadata();
        setState(() {
          if (metadata.updated != null) {
            cloudFileUpdatedTime =
                DateFormat('dd-MM-yyyy HH:mm').format(metadata.updated!);
          } else {
            cloudFileUpdatedTime = "";
          }
        });
      } on FirebaseException {
        setState(() {
          cloudFileUpdatedTime = "";
        });
      } catch (e) {
        setState(() {
          cloudFileUpdatedTime = "";
        });
      }
    } else {
      setState(() {
        cloudFileUpdatedTime = "";
      });
    }
  }

  void onBarcodeScannerPressed(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.barcode_scanner);
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<void> backup(BuildContext context, String filePath) async {
    try {
      String dbPath = await PathUtils().getDatabasePath();
      File source = File(dbPath);
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt > 29) {
          var status = await Permission.manageExternalStorage.status;
          if (!status.isGranted) {
            //openAppSettings();
            await Permission.manageExternalStorage.request();
          }
        } else {
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            await Permission.storage.request();
          }
        }
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }
      await source.copy(filePath);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context)!.backup_successful + " " + filePath),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context)!.backup_error + " " + e.toString()),
      ));
    }
  }

  void onBackUpPressed(BuildContext context) async {
    final dateFormat = new DateFormat('dd-MM-yyyy-HH-mm');
    final timeStamp = dateFormat.format(DateTime.now());
    String fileName = "appviet_goodmanager_database_$timeStamp.db";
    if (Platform.isWindows) {
      String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Please select an output file:', fileName: fileName);
      if (outputFile != null) {
        await backup(context, outputFile);
      }
    } else {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        String outputFile = selectedDirectory + fileName;
        await backup(context, outputFile);
      }
    }
  }

  void onRestorePressed(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      restore(context, result.files.single.path!);
    } else {
      // User canceled the picker
    }
  }

  void restore(BuildContext context, String filePath) async {
    try {
      File source = File(filePath);
      String dbPath = await PathUtils().getDatabasePath();
      //File file = File(dbPath);
      //if (await file.exists()){
      //   await file.delete();
      //}
      await source.copy(dbPath);
      ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("restore error: " + e.toString()),
      ));
    }
  }

  void onCloudPressed(BuildContext context) async {
    //upload
    String dbPath = await PathUtils().getDatabasePath();
    File file = File(dbPath);
    final storageRef = FirebaseStorage.instance.ref();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final ref = storageRef.child("$uid/database.db");
      try {
        await ref.putFile(file);
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarWhenSuccess(context));
        loadCloudFileUpdatedTime();
      } on FirebaseException {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarWhenFailure(context));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarWhenFailure(context));
      }
    }
  }

  void onQuickSyncPressed(BuildContext context) {
    justLogin = true;
    Navigator.of(context).pushNamedAndRemoveUntil(
        Pages.loading_data, (Route<dynamic> route) => false);
  }
}
