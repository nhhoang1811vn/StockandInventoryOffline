
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/db_service.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/db/db_helper.dart';

part 'menu_cubit.freezed.dart';
part 'menu_state.dart';

@injectable
class MenuCubit extends Cubit<MenuState>{
  MenuCubit() : super(MenuState.initial());

  Future<bool> deleteAccount() async {
    await FirebaseAuth.instance.currentUser?.delete();
    return signOut();
  }
  Future<bool> signOut() async{
    await FirebaseAuth.instance.signOut();
    await FirebaseAuth.instance.signInAnonymously();

    DBHelper dbHelper = DBHelper();
    await dbHelper.reset();

    // await AppSettings.reset();
    // await storeRepository.reset();
    // await purchaseRepository.removeAll();
    return Future.value(true);
  }
  Future<bool> upload() async{
    final db = await DBHelper().db;
    final service = DbService(db);
    final file = await service.exportToJson();
    final storageRef = FirebaseStorage.instance.ref();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final ref = storageRef.child("2026/$uid/data.json");
        await ref.putFile(file);
        return true;
      } on FirebaseException {
        return false;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}