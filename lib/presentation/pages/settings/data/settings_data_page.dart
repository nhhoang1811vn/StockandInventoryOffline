import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/data/data.dart';
import 'package:good_manager/presentation/dialog/custom_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../data/db_service.dart';
import '../../../widget/widget.dart';
import 'bloc/settings_data_cubit.dart';
import '../../../../util/toast_utils.dart';

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
        return SettingsScaffold(
          title: context.tr("menu_item_backup_and_restore"),
          body: _buildBody(),
        );
      },
    );
  }


  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        SettingsMenuCard(
          children: [
            SettingsMenuItem(
              icon: Icons.backup_outlined,
              title: context.tr("menu_back_up"),
              subtitle: context.tr("menu_back_up_desc"),
              onTap: () => onBackUpPressed(context),
            ),
            SettingsMenuItem(
              icon: Icons.restore_outlined,
              title: context.tr("menu_restore"),
              subtitle: context.tr("menu_restore_desc"),
              onTap: () => onRestorePressed(context),
              isLast: true,
            ),
          ],
        ),
        if (user != null && user?.isAnonymous == false) ...[
          SettingsSectionHeader(context.tr("cloud")),
          SettingsMenuCard(
            children: [
              SettingsMenuItem(
                icon: Icons.cloud_outlined,
                title: context.tr("menu_push_data_to_cloud"),
                subtitle: cloudFileUpdatedTime.isEmpty
                    ? context.tr("cloud_file_no_updated")
                    : cloudFileUpdatedTime,
                onTap: () => onCloudPressed(),
              ),
              SettingsMenuItem(
                icon: Icons.cloud_sync_outlined,
                title: context.tr("menu_push_data_to_cloud_v2"),
                subtitle: context.tr("menu_push_data_to_cloud_v2_desc"),
                onTap: onSaveDataToCloudVersion2,
                isLast: true,
              ),
            ],
          ),
        ],
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
      ToastUtils.showSuccessToast(context.tr("backup_successful") + " " + filePath);
    } catch (e) {
      ToastUtils.showErrorToast(context.tr("backup_error") + " " + e.toString());
    }
  }*/

  // void onBackUpPressed(BuildContext context) async {
  //   try {
  //     showProgressIndicator(context);
  //     checkPermission();
  //     final db = await DBHelper().db;
  //     final service = DbService(db);
  //     final file = await service.exportToJson();
  //     String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  //     if (selectedDirectory != null) {
  //       final fileName = p.basename(file.path);
  //       final outputPath = p.join(selectedDirectory, fileName);
  //       await file.copy(outputPath);
  //       notifyBackupSuccess(outputPath);
  //     }
  //   } catch(e){
  //     notifyBackupError(e.toString());
  //   } finally {
  //     hideDialog(context);
  //   }
  // }



  Future<void> onBackUpPressed(BuildContext context) async {
    try {
      showProgressIndicator(context);

      checkPermission();

      final db = await DBHelper().db;
      final service = DbService(db);

      // Export json file
      final exportedFile = await service.exportToJson();

      // Create backup folder in app documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory(
        p.join(appDocDir.path, 'backups'),
      );

      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Create final backup file path
      final fileName =
          'backup_${DateTime.now().millisecondsSinceEpoch}.json';

      final backupPath = p.join(backupDir.path, fileName);

      // Copy exported file to backup location
      final backupFile = await exportedFile.copy(backupPath);

      // Share file
      /*await SharePlus.instance.share(
        ShareParams(
          files: [XFile(backupFile.path)],
          text: 'Stock Inventory Backup',
          subject: 'Backup File',
        ),
      );*/
      final box = context.findRenderObject() as RenderBox?;
      final params = ShareParams(
        files: [XFile(backupFile.path)],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      await SharePlus.instance.share(params);

      unawaited(FirebaseAnalytics.instance.logEvent(
          name: 'backup_success'
      ));
      notifyBackupSuccess(backupFile.path);
    } catch (e) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'backup_failed',
        parameters: {
          'error': e.toString(),
        },
      ));
      notifyBackupError(e.toString());
    } finally {
      hideDialog(context);
    }
  }

  void onRestorePressed(BuildContext context) async {
    final result = await FilePicker.pickFile();
    final path = result?.path;
    if (path != null) {
      restore(context, path);
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
        ToastUtils.showSuccessToast(context.tr("snackbar_saved"));
        loadCloudFileUpdatedTime();
      }
      catch (e) {
        if (!mounted) {
          return;
        }
        ToastUtils.showErrorToast(context.tr("snackbar_try_again"));
      }
    }
  }

  void onSaveDataToCloudVersion2() async {
    showProgressIndicator(context);
    final error = await context.read<SettingsDataCubit>().syncToRealtimeDB();
    hideDialog(context);
    if (error == null) {
      ToastUtils.showSuccessToast(context.tr("snackbar_saved"));
    } else {
      ToastUtils.showErrorToast(error);
    }
  }

  void notifyBackupSuccess(String path){
    ToastUtils.showSuccessToast(context.tr("backup_successful") + " " + path);
  }
  void notifyBackupError(String error) {
    ToastUtils.showErrorToast(context.tr("backup_error") + " " + error);
  }
  void notifyRestoreSuccess(){
    ToastUtils.showSuccessToast(context.tr("snackbar_saved"));
  }
  void notifyRestoreError(String error) {
    ToastUtils.showErrorToast(sprintf(context.tr("restore_error"), [error]));
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
