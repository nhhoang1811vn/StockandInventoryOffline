import 'dart:io';

import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/common/path_utils.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../db/db_helper.dart';

part 'auth_state.dart';


@injectable
class AuthCubit extends Cubit<AuthState> {
  final StoresUseCase useCase;
  final Storage storage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCubit({required this.useCase, required this.storage}) : super(AuthInitial());

  void downloadUserData() async{
    downloadDBFile((state){
      if (state == TaskState.success){
        print("taskstate success");
        checkStore();
      }else if (state == TaskState.canceled || state == TaskState.error){
        print("taskstate error");
        checkStore();
      }
    });
  }
  void checkStore() async{
    await Future.delayed(Duration(seconds: 2));
    try{
      if (Platform.isIOS){
        DBHelper dbHelper = DBHelper();
        await dbHelper.reopen();
      }
      final stores = await useCase.getAll();
      if (stores.isNotEmpty){
        await updateSelectedStore();
        emit(UserSignInSuccessfulWithStore());
      }else{
        emit(UserSignInSuccessfulWithNoStore());
      }
    }catch (e) {
      emit(UserSignInSuccessfulWithNoStore());
    }
  }
  Future<void> updateSelectedStore() async {
    final storeId = storage.getSelectedStoreId();
    final stores = await useCase.getAll();
    var matched = false;
    for (var store in stores){
      if (storeId != -1 && storeId == store.id){
        matched = true;
        break;
      }
    }
    if (!matched){
      storage.setSelectedStoreId(stores.first.id!);
      storage.setSelectedStoreName(stores.first.name);
    }
  }
  String getCloudFilePath(){
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null){
      return "$uid/database.db";
    }else{
      throw Exception("file not found");
    }
  }
  void downloadDBFile(Function(TaskState) callback) async{
    final storageRef = FirebaseStorage.instance.ref();
    try{
      final filePath = getCloudFilePath();
      final fileRef = storageRef.child(filePath);
      String dbPath = await PathUtils().getDatabasePath();
      final dbFile = File(dbPath);
      await fileRef.getDownloadURL();
      final downloadTask = fileRef.writeToFile(dbFile);
      downloadTask.snapshotEvents.listen((taskSnapshot) {
        callback(taskSnapshot.state);
      });
    }
    on FirebaseException{
      callback(TaskState.error);
    }
    on Exception{
      callback(TaskState.canceled);
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(ResetPasswordSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user!.emailVerified) {
        emit(UserSignIn());
      } else {
        await _auth.signOut();
        emit(UserNotVerified());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  Future<void> signInWithGoogleInWindowPlatform() async{
    final googleSignInArgs = GoogleSignInArgs(
      clientId:
      '617423800641-s9j7uem4h2u0751pc1im6o34e4resoi4.apps.googleusercontent.com',
      redirectUri:
      'https://quanlykho-4818e.firebaseapp.com/__/auth/handler',
      scope: 'email',
    );
    try {
      final result = await DesktopWebviewAuth.signIn(googleSignInArgs);

      final newCredential = GoogleAuthProvider.credential(
        accessToken: result?.accessToken,
        idToken: result?.idToken,
      );
      await _auth.signInWithCredential(newCredential);
      emit(UserSignIn());
    } catch (err) {
      emit(AuthError(err.toString()));
    }
  }
  Future<void> signInWithApple() async{
    emit(AuthLoading());
    try {
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');
      final userCredential = await _auth.signInWithProvider(appleProvider);
      //print(userCredential.credential?.accessToken);
      //print(userCredential.user?.email);
      //print(userCredential.user?.emailVerified);
      emit(UserSignIn());
      /*if (userCredential.user!.emailVerified) {
        emit(UserSignIn());
      } else {
        await _auth.signOut();
        emit(UserNotVerified());
      }*/
    } catch (e) {
      if (e.toString().contains("An unknown error has occurred")){
        emit(AuthStopped());
      }else{
        emit(AuthError(e.toString()));
      }
    }
  }
  Future<void> signInWithGoogle() async {
    //final String googleClientId = "617423800641-s9j7uem4h2u0751pc1im6o34e4resoi4.apps.googleusercontent.com";
    emit(AuthLoading());
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
          //clientId: googleClientId
      ).signIn();
      if (googleUser == null) {
        //emit(AuthError('Google Sign In Failed'));
        emit(AuthStopped());
        return;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      emit(UserSignIn());
      //downloadUserData();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    await _auth.signOut();
    emit(UserSignedOut());
  }

  Future<void> signUpWithEmail(
      String name, String email, String password) async {
    emit(AuthLoading());
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _auth.currentUser!.updateDisplayName(name);
      await _auth.currentUser!.sendEmailVerification();
      await _auth.signOut();
      emit(UserSingupButNotVerified());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}