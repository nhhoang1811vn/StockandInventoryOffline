import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/pages.dart';

class ImagesPreviewController extends Controller {
  int selectedPosition = 0;
  List<String> items = [];
  final void Function(List<String>) onDataChanged;
  PageController pageController = PageController();
  ImagesPreviewController(this.items, this.onDataChanged) : super();

  @override
  void initListeners() {}

  void onPageChanged(int position){
    print("onPageChanged: $position");
    selectedPosition = position;
    refreshUI();
  }

  void onDeleteItem(){
    items.removeAt(selectedPosition);
    notifyItemsChanged();
    if (selectedPosition == items.length){
      selectedPosition--;
    }
    refreshUI();
  }
  void showConfirmDeleteFile() {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(getContext()).notification_dialog_title),
            content: Text(
                AppLocalizations.of(getContext()).message_confirm_delete_file),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(getContext()),
                  child: Text(AppLocalizations.of(getContext()).action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(getContext());
                  onDeleteItem();
                },
                child: Text(AppLocalizations.of(getContext()).action_ok),
              )
            ],
          );
        });
  }

  void onAddPhotoPressed() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    if (result != null) {
      items.addAll(result.paths);
      notifyItemsChanged();
      refreshUI();
    }
  }

  void onTakePhotoPressed() async {
    final result = await Navigator.of(getContext())
        .pushReplacementNamed(Pages.take_picture);
    if (result != null) {
      items.add(result);
      notifyItemsChanged();
      refreshUI();
    }
  }
  //horizontal list view
  void onListViewItemPressed(int position){
    print("onListViewItemPressed: $position");
    selectedPosition = position;
    pageController.animateToPage(position, duration: Duration(milliseconds: 300), curve: Curves.ease);
    refreshUI();
  }
  void onNextButtonPressed(){
    selectedPosition++;
    pageController.animateToPage(selectedPosition, duration: Duration(milliseconds: 300), curve: Curves.ease);
    refreshUI();
  }
  void onPrevButtonPressed(){
    selectedPosition--;
    pageController.animateToPage(selectedPosition, duration: Duration(milliseconds: 300), curve: Curves.ease);
    refreshUI();
  }
  void notifyItemsChanged(){
    onDataChanged(items);
  }
}