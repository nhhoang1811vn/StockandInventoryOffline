import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/data/db_service.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../data/app_settings.dart';
import '../../../data/data.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final StoresUseCase useCase;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit({required this.useCase}) : super(AuthInitial());


  void downloadUserData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final firebasePath = "2026/$uid/data.json";
      final localFileName = "data.json";
      final file = await downloadFile(firebasePath, localFileName);
      if (file != null) {
        final db = await DBHelper().db;
        final service = DbService(db);
        await service.importFromFile(file);
      }
    }
    checkStore();
  }

  void checkStore() async {
    //await Future.delayed(Duration(seconds: 2));
    try {
      /*if (Platform.isIOS) {
        DBHelper dbHelper = DBHelper();
        await dbHelper.reopen();
      }*/
      final stores = await useCase.getAll();
      if (isClosed) return;
      if (stores.isNotEmpty) {
        await updateSelectedStore();
        if (isClosed) return;
        emit(UserSignInSuccessfulWithStore());
      } else {
        emit(UserSignInSuccessfulWithNoStore());
      }
    } catch (e) {
      if (isClosed) return;
      emit(UserSignInSuccessfulWithNoStore());
    }
  }

  Future<void> updateSelectedStore() async {
    final storeId = AppSettings.getSelectedStoreId();
    final stores = await useCase.getAll();
    var matched = false;
    for (var store in stores) {
      if (storeId != -1 && storeId == store.id) {
        matched = true;
        break;
      }
    }
    if (!matched && stores.isNotEmpty) {
      AppSettings.setSelectedStoreId(stores.first.id!);
      AppSettings.setSelectedStoreName(stores.first.name);
    }
  }

  String getCloudFilePath() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      return "2026/$uid/data.json";
    } else {
      throw Exception("file not found");
    }
  }

  Future<File?> downloadFile(String firebasePath, String localFileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref(firebasePath);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$localFileName');
      await storageRef.writeToFile(file);
      return file;
    } catch (ex) {
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (isClosed) return;
      emit(ResetPasswordSent());
    } catch (e) {
      if (isClosed) return;
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (isClosed) return;
      emit(UserSignIn());
    } on FirebaseAuthException catch (e) {
      if (isClosed) return;
      handleFirebaseAuthError(e);
    }
  }

  void handleFirebaseAuthError(e) {
    String error = "";
    switch (e.code) {
      case "provider-already-linked":
        error = "auth_provider_already_linked".tr();
        break;
      case "invalid-credential":
        error = "auth_invalid_credential".tr();
        break;
      case "credential-already-in-use":
        error = "auth_credential_already_in_use".tr();
        break;
      case "email-already-in-use":
        error = "auth_email_already_in_use".tr();
        break;
      default:
        error = "auth_unknown_error".tr();
    }
    emit(AuthError(error));
  }

  Future<void> signInWithApple() async {
    emit(AuthLoading());
    try {
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
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      if (isClosed) return;
      //emit(AuthStopped());
      //downloadData();
      emit(UserSignIn());
    } on FirebaseAuthException catch (e) {
      if (isClosed) return;
      handleFirebaseAuthError(e);
    }
  }

  // Future<void> signInWithGuest() async {
  //   emit(AuthLoading());
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInAnonymously();
  //     emit(UserSignIn());
  //   } on FirebaseAuthException catch (e) {
  //     handleFirebaseAuthError(e);
  //   }
  // }

  // Future<void> signInWithGoogle() async {
  //   emit(AuthLoading());
  //   try {
  //     await GoogleSignIn().signOut();
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       emit(AuthStopped());
  //       return;
  //     }
  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     final User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null && user.isAnonymous) {
  //       await user.linkWithCredential(credential);
  //     } else {
  //       await _auth.signInWithCredential(credential);
  //     }
  //     emit(UserSignIn());
  //   } on FirebaseAuthException catch (e) {
  //     handleFirebaseAuthError(e);
  //   }
  // }
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      var credential = await getGoogleCredential();
      await _auth.signInWithCredential(credential);
      if (isClosed) return;
      emit(UserSignIn());
      //downloadData();
    } on FirebaseAuthException catch (e) {
      if (isClosed) return;
      handleFirebaseAuthError(e);
    } on Exception {
      if (isClosed) return;
      emit(AuthStopped());
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    await _auth.signOut();
    if (isClosed) return;
    emit(UserSignedOut());
  }

  Future<void> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    emit(AuthLoading());
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.updateDisplayName(name);
      //await _auth.currentUser!.sendEmailVerification();
      //await _auth.signOut();
      if (isClosed) return;
      emit(UserSingupButNotVerified());
    } on FirebaseAuthException catch (e) {
      if (isClosed) return;
      handleFirebaseAuthError(e);
    }
  }

  Future<OAuthCredential> getGoogleCredential() async {
    await GoogleSignIn().signOut();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception("google User is null");
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return credential;
  }

  Future<void> linkWithGoogle() async {
    emit(AuthLoading());
    try {
      var credential = await getGoogleCredential();
      await _auth.currentUser!.linkWithCredential(credential);
      if (isClosed) return;
      emit(AuthStopped());
      emit(UserLinkSuccessful());
      //uploadData();
    } on FirebaseAuthException catch (e) {
      if (isClosed) return;
      handleFirebaseAuthError(e);
    } on Exception {
      if (isClosed) return;
      emit(AuthStopped());
    }
  }

  Future<void> linkWithApple() async {
    emit(AuthLoading());
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await _auth.currentUser!.linkWithCredential(credential);

      if (isClosed) return;
      emit(AuthStopped());
      emit(UserLinkSuccessful());
      //uploadData();
    } on FirebaseAuthException catch (e) {
      if (isClosed) return;
      handleFirebaseAuthError(e);
    } on Exception {
      if (isClosed) return;
      emit(AuthStopped());
    }
  }

  Future<void> linkWithEmail(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser!.linkWithCredential(credential);
      await _auth.currentUser!.updateDisplayName(name);
      if (isClosed) return;
      emit(AuthStopped());
      emit(UserLinkSuccessful());
      //uploadData();
    } on FirebaseAuthException catch (e) {
      if (isClosed) return;
      handleFirebaseAuthError(e);
    } on Exception {
      if (isClosed) return;
      emit(AuthStopped());
    }
  }
}
