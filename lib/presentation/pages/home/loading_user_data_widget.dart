import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/common/path_utils.dart';
import 'package:good_manager/presentation/pages/home/bloc/loading_user_data_cubit.dart';
import 'package:good_manager/presentation/pages/pages.dart';

class LoadingUserDataWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoadingUserDataWidgetState();
  }
}
class LoadingUserDataWidgetState extends State<LoadingUserDataWidget>{
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    downloadDBFile((state){
      print("downloadDBFile $state");
      if (state == TaskState.success){
        checkStore();
      }else if (state == TaskState.canceled || state == TaskState.error){
        checkStore();
      }
    });
  }
  void checkStore() async{
    final checkStores = await context.read<LoadingUserDataCubit>().checkStore();
    if (checkStores){
      //there is store
      await context.read<LoadingUserDataCubit>().updateSelectedStore();
      Navigator.of(context).pushNamedAndRemoveUntil(Pages.home, (route) => false);
    }else{
      //there is no store
      //go to onboard flow to create first store
      Navigator.of(context).pushNamedAndRemoveUntil(Pages.onboarding, (route) => false);
    }
  }
  void downloadDBFile(Function(TaskState) callback) async{
    print("downloadDBFile");
    final storageRef = FirebaseStorage.instance.ref();
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null){
      final filePath = "$email/database.db";
      final fileRef = storageRef.child(filePath);
      String dbPath = await PathUtils().getDatabasePath();
      final dbFile = File(dbPath);
      try{
        await fileRef.getDownloadURL();
        final downloadTask = fileRef.writeToFile(dbFile);
        downloadTask.snapshotEvents.listen((taskSnapshot) {
          callback(taskSnapshot.state);
        });
      }on FirebaseException {
        callback(TaskState.error);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}