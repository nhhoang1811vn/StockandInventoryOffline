import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/app_settings.dart';
import '../../../../../domain/entity/entity.dart';

part 'document_properties_cubit.freezed.dart';
part 'document_properties_state.dart';

@injectable
class DocumentPropertiesCubit extends Cubit<DocumentPropertiesState> {
  DocumentPropertiesCubit() : super(const DocumentPropertiesState.initial());

  void init() {
    final settings = AppSettings.getDocumentPropertiesSettings();
    emit(
      state.copyWith(
        showImage: settings.showImage,
        showDocumentNo: settings.showDocumentNo,
        showDateTime: settings.showDateTime,
        showDescription: settings.showDescription,
      ),
    );
  }

  void onShowImageChanged(bool value) {
    emit(state.copyWith(showImage: value));
    _save();
  }

  void onShowDocumentNoChanged(bool value) {
    emit(state.copyWith(showDocumentNo: value));
    _save();
  }

  void onShowDateTimeChanged(bool value) {
    emit(state.copyWith(showDateTime: value));
    _save();
  }

  void onShowDescriptionChanged(bool value) {
    emit(state.copyWith(showDescription: value));
    _save();
  }

  void _save() {
    AppSettings.setDocumentPropertiesSettings(
      DocumentPropertiesSettings(
        showImage: state.showImage,
        showDocumentNo: state.showDocumentNo,
        showDateTime: state.showDateTime,
        showDescription: state.showDescription,
      ),
    );
  }
}
