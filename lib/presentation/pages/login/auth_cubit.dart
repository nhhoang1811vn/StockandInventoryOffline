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

part 'auth_state.dart';


@injectable
class AuthCubit extends Cubit<AuthState> {
  final StoresUseCase useCase;
  final Storage storage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCubit({required this.useCase, required this.storage}) : super(AuthInitial());

  void downloadUserData() async{
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
    final stores = await useCase.getAll();
    if (stores.isNotEmpty){
      updateSelectedStore();
      emit(UserSignInSuccessfulWithStore());
    }else{
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
    //firstTimeLogin = true;
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user!.emailVerified) {
        //emit(UserSignIn());
        downloadUserData();
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
      //emit(UserSignIn());
      downloadUserData();
    } catch (err) {
      // something went wrong
    }
  }
  Future<void> signInWithApple() async{
    emit(AuthLoading());
    try {
      final appleProvider = AppleAuthProvider();
      final userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
      //emit(UserSignIn());
      downloadUserData();
      /*if (userCredential.user!.emailVerified) {
        emit(UserSignIn());
      } else {
        await _auth.signOut();
        emit(UserNotVerified());
      }*/
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  Future<void> signInWithGoogle() async {
    //firstTimeLogin = true;
    final String googleClientId = "617423800641-s9j7uem4h2u0751pc1im6o34e4resoi4.apps.googleusercontent.com";
    emit(AuthLoading());
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn(clientId: googleClientId).signIn();
      if (googleUser == null) {
        emit(AuthError('Google Sign In Failed'));
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
      //emit(UserSignIn());
      downloadUserData();
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