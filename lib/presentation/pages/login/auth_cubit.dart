import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart';
import 'package:good_manager/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final StoresUseCase useCase;
  final Storage storage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCubit({required this.useCase, required this.storage}) : super(AuthInitial());

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
    firstTimeLogin = true;
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


  Future<void> signInWithGoogle() async {
    firstTimeLogin = true;
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
      emit(UserSignIn());
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