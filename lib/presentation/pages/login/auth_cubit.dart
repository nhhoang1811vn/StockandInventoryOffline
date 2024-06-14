import 'dart:io';

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

  /*Future<void> createAccountAndLinkItWithGoogleAccount(
      String email,
      String password,
      GoogleSignInAccount googleUser,
      OAuthCredential credential) async {
    emit(AuthLoading());

    try {
      await _auth.createUserWithEmailAndPassword(
        email: googleUser.email,
        password: password,
      );
      await _auth.currentUser!.linkWithCredential(credential);
      await _auth.currentUser!.updateDisplayName(googleUser.displayName);
      await _auth.currentUser!.updatePhotoURL(googleUser.photoUrl);
      emit(UserSingupAndLinkedWithGoogle());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }*/

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(ResetPasswordSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  Future<bool> checkStore() async{
    final stores = await useCase.getAll();
    return Future.value(stores.isNotEmpty);
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
  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user!.emailVerified) {
        downloadDBFile((state){
          if (state == TaskState.success){
            emit(UserSignIn());
          }else if (state == TaskState.canceled || state == TaskState.error){
            emit(UserSignIn());
          }
        });
      } else {
        await _auth.signOut();
        //emit(AuthError('Email not verified. Please check your email.'));
        emit(UserNotVerified());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  void downloadDBFile(Function(TaskState) callback) async{
    final storageRef = FirebaseStorage.instance.ref();
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null){
      final filePath = "$email/database.db";
      final fileRef = storageRef.child(filePath);
      String dbPath = await PathUtils().getDatabasePath();
      final dbFile = File(dbPath);
      try{
        final downloadUrl = await fileRef.getDownloadURL();
        final downloadTask = fileRef.writeToFile(dbFile);
        downloadTask.snapshotEvents.listen((taskSnapshot) {
          callback(taskSnapshot.state);
        });
      }on FirebaseException catch (e) {
        callback(TaskState.error);
      }
    }
  }

  Future<void> signInWithGoogle() async {
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
      final UserCredential authResult =
      await _auth.signInWithCredential(credential);
      /*if (authResult.additionalUserInfo!.isNewUser) {
        // Delete the user account if it is a new user to Create it automatically in Next Screen
        await _auth.currentUser!.delete();

        emit(IsNewUser(googleUser: googleUser, credential: credential));
      } else {
        emit(UserSignIn());
      }*/
      //emit(UserSignIn());
      downloadDBFile((state){
        if (state == TaskState.success){
          emit(UserSignIn());
        }else if (state == TaskState.canceled || state == TaskState.error){
          emit(UserSignIn());
        }
      });

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