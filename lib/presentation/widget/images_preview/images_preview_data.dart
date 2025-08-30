part of 'images_preview_cubit.dart';

@freezed
class ImagesPreviewData with _$ImagesPreviewData {
  const factory ImagesPreviewData.initial({
    required ImagesPreviewState state,
    @Default(0) int selectedPosition,
    @Default([]) List<Uint8List> items,
  }) = _Initial;
}
