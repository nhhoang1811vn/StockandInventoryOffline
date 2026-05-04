import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/data/data.dart';
import 'package:good_manager/presentation/dialog/custom_dialog.dart';
import 'package:good_manager/presentation/widget/views.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '../../../../data/db_service.dart';
import '../../../widget/snackbar_widgets.dart';
import 'bloc/settings_data_cubit.dart';

class SettingsDataPage extends StatefulWidget {
  SettingsDataPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsDataPageState();
  }
}

class SettingsDataPageState extends State<SettingsDataPage> {
  var cloudFileUpdatedTime = "";
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadCloudFileUpdatedTime();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsDataCubit, SettingsDataState>(
      listener: (context, state) async {},
      builder: (BuildContext context, SettingsDataState state) {
        return Scaffold(
          appBar: new AppBar(
            title: new Text(context.tr("menu_item_backup_and_restore")),
          ),
          body: _buildBody(),
        );
      },
    );
  }


  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.backup),
                title: Text(context.tr("menu_back_up")),
                subtitle: Text(context.tr("menu_back_up_desc")),
                onTap: () => onBackUpPressed(context),
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.restore),
                title: Text(context.tr("menu_restore")),
                subtitle: Text(context.tr("menu_restore_desc")),
                onTap: () => onRestorePressed(context),
              ),
            ],
          ),
        ),
        if (user != null && user?.isAnonymous == false)
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                  ListTile(
                    leading: Icon(Icons.cloud),
                    title: Text(context.tr("menu_push_data_to_cloud")),
                    subtitle: cloudFileUpdatedTime.isEmpty
                        ? Text(context.tr("cloud_file_no_updated"))
                        : Text(cloudFileUpdatedTime),
                    onTap: () => onCloudPressed(),
                  ),
                  ListTile(
                    leading: Icon(Icons.cloud),
                    title: Text("Save the data to cloud v2"),
                    subtitle: Text("Use this option to make your offline Stock & Inventory data available in the online version."),
                    onTap: () {
                      onSaveDataToCloudVersion2();
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }

  void loadCloudFileUpdatedTime() async {
    final storageRef = FirebaseStorage.instance.ref();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final ref = storageRef.child("2026/$uid/data.json");
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

  /*Future<void> backup(BuildContext context, String filePath) async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr("backup_successful") + " " + filePath,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr("backup_error") + " " + e.toString(),
          ),
        ),
      );
    }
  }*/

  void onBackUpPressed(BuildContext context) async {
    try {
      showProgressIndicator(context);
      checkPermission();
      final db = await DBHelper().db;
      final service = DbService(db);
      final file = await service.exportToJson();
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        final fileName = p.basename(file.path);
        final outputPath = p.join(selectedDirectory, fileName);
        await file.copy(outputPath);
        notifyBackupSuccess(outputPath);
      }
    } catch(e){
      notifyBackupError(e.toString());
    } finally {
      hideDialog(context);
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
  // Future<Map<String, dynamic>> readJson(File file) async {
  //   final jsonString = await file.readAsString();
  //   return jsonDecode(jsonString) as Map<String, dynamic>;
  // }

  void restore(BuildContext context, String filePath) async {
    try {
      File file = File(filePath);
      final db = await DBHelper().db;
      final service = DbService(db);
      await service.importFromFile(file);
      notifyRestoreSuccess();
    } catch (e) {
      notifyRestoreError(e.toString());
    } finally {

    }
  }

  void onCloudPressed() async {
    //save data to Firebase Storage
    final db = await DBHelper().db;
    final service = DbService(db);
    final file = await service.exportToJson();
    final storageRef = FirebaseStorage.instance.ref();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final ref = storageRef.child("2026/$uid/data.json");
      try {
        await ref.putFile(file);
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarWhenSuccess(context));
        loadCloudFileUpdatedTime();
      }
      catch (e) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarWhenFailure(context));
      }
    }
  }

  void onSaveDataToCloudVersion2() async {
    showProgressIndicator(context);
    final error = await context.read<SettingsDataCubit>().syncToRealtimeDB();
    hideDialog(context);
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailureWithText(error));
    }
  }

  void notifyBackupSuccess(String path){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.tr("backup_successful") + " " + path,
        ),
      ),
    );
  }
  void notifyBackupError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.tr("backup_error") + " " + error,
        ),
      ),
    );
  }
  void notifyRestoreSuccess(){
    ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
  }
  void notifyRestoreError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("restore error: " + error),
      ),
    );
  }
  void checkPermission() async{
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
  }
}
