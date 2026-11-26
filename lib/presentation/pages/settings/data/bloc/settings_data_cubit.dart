import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'settings_data_cubit.freezed.dart';
part 'settings_data_state.dart';

@injectable
class SettingsDataCubit extends Cubit<SettingsDataState> {
  SettingsDataCubit() : super(SettingsDataState.initial());
}
