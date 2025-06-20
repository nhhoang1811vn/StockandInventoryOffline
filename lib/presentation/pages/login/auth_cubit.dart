import 'dart:io';

import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/common/path_utils.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
    User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      if (currentUser != null && currentUser.isAnonymous) {
        final credential = EmailAuthProvider.credential(email: email, password: password);
        await currentUser.linkWithCredential(credential);
      } else {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      emit(UserSignIn());
    }
    on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    }
  }
  void handleFirebaseAuthError(e){
    String error = "";
    switch (e.code) {
      case "provider-already-linked":
        error = "The provider has already been linked to the user.";
        break;
      case "invalid-credential":
        error = "The provider's credential is not valid.";
        break;
      case "credential-already-in-use":
        error = "The account corresponding to the credential already exists, or is already linked to a Firebase User.";
        break;
      case "email-already-in-use":
        error = "The email is already in used";
        break;
      default:
        error = "Unknown error.";
    }
    emit(AuthError(error));
  }
  // Future<void> signInWithGoogleInWindowPlatform() async{
  //   final googleSignInArgs = GoogleSignInArgs(
  //     clientId:
  //     '617423800641-s9j7uem4h2u0751pc1im6o34e4resoi4.apps.googleusercontent.com',
  //     redirectUri:
  //     'https://quanlykho-4818e.firebaseapp.com/__/auth/handler',
  //     scope: 'email',
  //   );
  //   try {
  //     final result = await DesktopWebviewAuth.signIn(googleSignInArgs);
  //
  //     final newCredential = GoogleAuthProvider.credential(
  //       accessToken: result?.accessToken,
  //       idToken: result?.idToken,
  //     );
  //     await _auth.signInWithCredential(newCredential);
  //     emit(UserSignIn());
  //   } catch (err) {
  //     emit(AuthError(err.toString()));
  //   }
  // }
  Future<void> signInWithApple() async{
    emit(AuthLoading());
    try {
      // final appleProvider = AppleAuthProvider();
      // appleProvider.addScope('email');
      // appleProvider.addScope('name');
      // var credential = await _auth.signInWithProvider(appleProvider);
      //
      //
      // final user = FirebaseAuth.instance.currentUser;
      //
      // if (user != null && user.isAnonymous) {
      //   await user.linkWithCredential(credential);
      //   //print("Anonymous account linked to Apple ID.");
      // } else {
      //   //print("User is not anonymous or not logged in.");
      // }
      // emit(UserSignIn());
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.isAnonymous) {
        await user.linkWithCredential(oauthCredential);
      } else {
      }
      emit(UserSignIn());
    }on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    }
  }
  Future<void> signInWithGuest() async{
    emit(AuthLoading());
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      emit(UserSignIn());
    }on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    }
  }
  Future<void> signInWithGoogle() async {
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
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.isAnonymous) {
        await user.linkWithCredential(credential);
      } else {
        await _auth.signInWithCredential(credential);
      }
      emit(UserSignIn());
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
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
    } on FirebaseAuthException catch (e) {
    handleFirebaseAuthError(e);
    }
  }
}