import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'menu_cubit.freezed.dart';
part 'menu_state.dart';

@injectable
class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuState.initial());
}
