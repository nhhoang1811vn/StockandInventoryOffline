import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/presentation/widgets/images_preview/images_preview_state.dart';

part 'images_preview_cubit.freezed.dart';
part 'images_preview_data.dart';

class ImagesPreviewCubit extends Cubit<ImagesPreviewData> {
  ImagesPreviewCubit() : super(ImagesPreviewData.initial(state: ImagesPreviewStateInitial()));
  PageController pageController = PageController();


  void onPageChanged(int position){
    emit(state.copyWith(selectedPosition: position));
  }

  void onDeleteItem(){
    List<String> items = state.items;
    items.removeAt(state.selectedPosition);

    int newSelectedPosition = state.selectedPosition;
    if (state.selectedPosition == items.length){
      newSelectedPosition--;
    }
    emit(state.copyWith(state: DataChangedState(), selectedPosition: newSelectedPosition));
  }
  void onDeleteButtonClicked() {
    emit(state.copyWith(state: ShowDeletePopupState()));
  }

  void onAddPhotoPressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);
    if (result != null) {
      List<String> items = [];
      items.addAll(state.items);
      for (String? item in result.paths){
        if (item != null){
          items.add(item);
        }
      }
      emit(state.copyWith(state : DataChangedState(),items: items));
    }
  }

  void onTakePhotoPressed() async {
    emit(state.copyWith(state: TakePictureState()));
  }
  //horizontal list view
  void onListViewItemPressed(int position){
    /*print("onListViewItemPressed: $position");
    selectedPosition = position;
    pageController.animateToPage(position, duration: Duration(milliseconds: 300), curve: Curves.ease);
    refreshUI();*/
  }
  void onNextButtonPressed(){
    int newPosition = state.selectedPosition + 1;
    emit(state.copyWith(selectedPosition: newPosition));
    pageController.animateToPage(newPosition, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
  void onPrevButtonPressed(){
    int newPosition = state.selectedPosition - 1;
    emit(state.copyWith(selectedPosition: newPosition));
    pageController.animateToPage(newPosition, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
  void notifyItemsChanged(){
    //onDataChanged(items);
  }

  void onAddPhoto(String result) {
    List<String> items = [];
    items.addAll(state.items);
    items.add(result);
    emit(state.copyWith(state: DataChangedState(),items: items));
  }
}