import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'images_preview_controller.dart';

class ImagesPreviewView extends View {
  final List<String> items;
  final bool multipleImages;
  final void Function(List<String>) onDataChanged;

  ImagesPreviewView(this.items, this.multipleImages,this.onDataChanged) : super();

  @override
  ImagesPreviewState createState() {
    return ImagesPreviewState(ImagesPreviewController(items, onDataChanged));
  }
}

class ImagesPreviewState
    extends ViewState<ImagesPreviewView, ImagesPreviewController> {
  ImagesPreviewState(ImagesPreviewController controller) : super(controller);

  Widget get addPhotoButton => ControlledWidgetBuilder<ImagesPreviewController>(
          builder: (context, controller) {
        return MaterialButton(
            minWidth: 24,
            onPressed: controller.onAddPhotoPressed,
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              Icons.add_photo_alternate,
              size: 24,
            ),
            padding: EdgeInsets.all(8),
            shape: CircleBorder());
      });

  Widget get takePhotoButton =>
      ControlledWidgetBuilder<ImagesPreviewController>(
          builder: (context, controller) {
        return MaterialButton(
            minWidth: 24,
            onPressed: controller.onTakePhotoPressed,
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              Icons.add_a_photo,
              size: 24,
            ),
            padding: EdgeInsets.all(8),
            shape: CircleBorder());
      });

  Widget get previousButton => ControlledWidgetBuilder<ImagesPreviewController>(
          builder: (context, controller) {
        return MaterialButton(
            minWidth: 24,
            onPressed: controller.onPrevButtonPressed,
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              Icons.navigate_before,
              size: 24,
            ),
            padding: EdgeInsets.all(8),
            shape: CircleBorder());
      });

  Widget get nextButton => ControlledWidgetBuilder<ImagesPreviewController>(
          builder: (context, controller) {
        return MaterialButton(
            minWidth: 24,
            onPressed: controller.onNextButtonPressed,
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              Icons.navigate_next,
              size: 24,
            ),
            padding: EdgeInsets.all(8),
            shape: CircleBorder());
      });

  Widget get deleteButton => ControlledWidgetBuilder<ImagesPreviewController>(
          builder: (context, controller) {
        return MaterialButton(
            minWidth: 24,
            onPressed: controller.showConfirmDeleteFile,
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              Icons.clear,
              size: 24,
            ),
            padding: EdgeInsets.all(8),
            shape: CircleBorder());
      });

  Widget buildEmptyView() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [addPhotoButton, takePhotoButton],
        ),
      );

  //PageController pageController = PageController();

  Widget buildPageView() {
    return ControlledWidgetBuilder<ImagesPreviewController>(
        builder: (context, controller) {
      return Container(
          child: Stack(
            children: [
              PageView.builder(
                controller: controller.pageController,
                itemBuilder: (context, position) {
                  return createPage(controller.items[position]);
                },
                itemCount: controller.items.length,
                onPageChanged: controller.onPageChanged,
              ),

              Align(alignment: Alignment.centerLeft, child: Visibility(visible: controller.selectedPosition >0, child: previousButton)),
              Align(alignment: Alignment.centerRight, child: Visibility(visible: controller.selectedPosition < controller.items.length - 1, child: nextButton)),
              Align(alignment: Alignment.bottomRight, child: deleteButton)
            ],
          ));
    });
  }

  Widget createPage(String path) {
    return Container(
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            image: DecorationImage(
                image: FileImage(File(path)), fit: BoxFit.contain)));
  }

  @override
  Widget get view => ControlledWidgetBuilder<ImagesPreviewController>(
          builder: (context, controller) {
        return Column(key: globalKey, children: [topView(),SizedBox(height: 8,),if (controller.items.isNotEmpty && widget.multipleImages) bottomView()]);
      });

  Widget topView() {
    return ControlledWidgetBuilder<ImagesPreviewController>(
        builder: (context, controller) {
      return Container(
        height: 250,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child: controller.items.isEmpty ? buildEmptyView() : buildPageView(),
      );
    });
  }

  Widget bottomView() {
    return ControlledWidgetBuilder<ImagesPreviewController>(
        builder: (context, controller) {
      return Container(
        height: 120,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child: Row(
          children: [
            Expanded(child: ListView.builder(
                itemBuilder: (context, position) {
                  return GestureDetector(onTap: () => controller.onListViewItemPressed(position),child:  Container(
                      margin: EdgeInsets.only(left: 4, right: 4),
                      width: 80,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          border: position == controller.selectedPosition ? Border.all(color: Colors.blue) : null,
                          image: DecorationImage(
                              image: FileImage(File(controller.items[position])), fit: BoxFit.contain))
                  ));
                },
                itemCount: controller.items.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true)),
             Column(mainAxisAlignment: MainAxisAlignment.center,children: [addPhotoButton, takePhotoButton])
          ],
        ),
      );
    });
  }
}
