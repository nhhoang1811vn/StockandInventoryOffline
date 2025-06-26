import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/widgets/views.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/path_utils.dart';
import '../../../../main.dart';
import '../../../widgets/snackbar_widgets.dart';
import '../../pages.dart' show Pages;

class SettingsDataPage extends StatefulWidget {
  SettingsDataPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsDataPageState();
  }
}

class SettingsDataPageState extends State<SettingsDataPage> {
  var cloudFileUpdatedTime = "";
  @override
  void initState() {
    super.initState();
    loadCloudFileUpdatedTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text(AppLocalizations.of(context)!.menu_item_backup_and_restore)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(padding: EdgeInsets.all(16), children: [
      Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [

            ListTile(
              leading: Icon(Icons.backup),
              title: Text(AppLocalizations.of(context)!.menu_back_up),
              subtitle: Text(AppLocalizations.of(context)!.menu_back_up_desc),
              onTap: () => onBackUpPressed(context),
            ),
            buildDivider(),
            ListTile(
              leading: Icon(Icons.restore),
              title: Text(AppLocalizations.of(context)!.menu_restore),
              subtitle: Text(AppLocalizations.of(context)!.menu_restore_desc),
              onTap: () => onRestorePressed(context),
            ),
            buildDivider(),
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
            buildDivider(),
            ListTile(
              leading: Icon(Icons.sync),
              title: Text("Quick Sync"),
              subtitle: Text(
                  "It will restart the app, and sync the latest app data"),
              onTap: () => onQuickSyncPressed(context),
            ),
          ],
        ),
      )
    ]
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
