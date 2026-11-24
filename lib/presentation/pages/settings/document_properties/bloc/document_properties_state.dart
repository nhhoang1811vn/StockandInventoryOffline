part of 'document_properties_cubit.dart';

@freezed
class DocumentPropertiesState with _$DocumentPropertiesState {
  const factory DocumentPropertiesState.initial({
    @Default(true) bool showImage,
    @Default(true) bool showDocumentNo,
    @Default(true) bool showDateTime,
    @Default(true) bool showDescription,
  }) = _Initial;
}
