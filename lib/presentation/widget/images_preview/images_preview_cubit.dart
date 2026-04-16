import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/presentation/widget/images_preview/images_preview_state.dart';

part 'images_preview_cubit.freezed.dart';
part 'images_preview_data.dart';

class ImagesPreviewCubit extends Cubit<ImagesPreviewData> {
  ImagesPreviewCubit()
      : super(ImagesPreviewData.initial(state: ImagesPreviewStateInitial()));

  void onPageChanged(int position) {
    emit(state.copyWith(selectedPosition: position));
  }

  void onDeleteItem() {
    List<Uint8List> items = [];
    items.addAll(state.items);
    items.removeAt(state.selectedPosition);

    int newSelectedPosition = state.selectedPosition;
    if (state.selectedPosition == items.length) {
      newSelectedPosition--;
    }
    emit(
      state.copyWith(
        state: DataChangedState(),
        items: items,
        selectedPosition: newSelectedPosition,
      ),
    );
  }

  void onDeleteButtonClicked() {
    emit(state.copyWith(state: ShowDeletePopupState()));
  }

  void onAddPhotoPressed() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    if (result != null) {
      List<Uint8List> items = [];
      items.addAll(state.items);
      for (String? path in result.paths) {
        if (path != null) {
          final bytes = await File(path).readAsBytes();
          items.add(bytes);
        }
      }
      if (!isClosed) {
        emit(state.copyWith(state: DataChangedState(), items: items));
      }
    }
  }

  void onTakePhotoPressed() async {
    emit(state.copyWith(state: TakePictureState()));
  }

  void onListViewItemPressed(int position) {
    emit(
      state.copyWith(
        state: TransitionPageViewState(),
        selectedPosition: position,
      ),
    );
  }

  void onNextButtonPressed() {
    int newPosition = state.selectedPosition + 1;
    emit(
      state.copyWith(
        state: TransitionPageViewState(),
        selectedPosition: newPosition,
      ),
    );
  }

  void onPrevButtonPressed() {
    int newPosition = state.selectedPosition - 1;
    emit(
      state.copyWith(
        state: TransitionPageViewState(),
        selectedPosition: newPosition,
      ),
    );
  }

  void onAddPhoto(String path) {
    List<Uint8List> items = [];
    items.addAll(state.items);

    File file = File(path);
    items.add(file.readAsBytesSync());
    emit(state.copyWith(state: DataChangedState(), items: items));
  }

  void initState(List<Uint8List> items) {
    emit(state.copyWith(items: items));
  }
}
