import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/app/widgets/images_preview_data.dart';

import 'images_preview_cubit.dart';

class ImagesPreviewView extends StatefulWidget {
  final List<String> items;
  final bool multipleImages;
  final void Function(List<String>) onDataChanged;

  ImagesPreviewView(this.items, this.multipleImages, this.onDataChanged) : super();

  @override
  State<StatefulWidget> createState() {
    return ImagesPreviewViewState();
  }
}
class ImagesPreviewViewState extends State<ImagesPreviewView>{
  ImagesPreviewCubit cubit = ImagesPreviewCubit();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => cubit, child: _buildBody());
  }
  Widget _buildBody(){
    return BlocBuilder<ImagesPreviewCubit, ImagesPreviewData>(builder: (context, data) => Column(children: [_buildTopView(data),SizedBox(height: 8),if (data.items.isNotEmpty && widget.multipleImages) _buildBottomView(data)]));
  }
  Widget _buildAddPhotoButton() {
    return MaterialButton(
        minWidth: 24,
        onPressed: cubit.onAddPhotoPressed,
        color: Colors.blue,
        textColor: Colors.white,
        child: Icon(
          Icons.add_photo_alternate,
          size: 24,
        ),
        padding: EdgeInsets.all(8),
        shape: CircleBorder());
  }

  Widget _buildTakePhotoButton(){
      return MaterialButton(
          minWidth: 24,
          onPressed: cubit.onTakePhotoPressed,
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(
            Icons.add_a_photo,
            size: 24,
          ),
          padding: EdgeInsets.all(8),
          shape: CircleBorder());
  }

  Widget get previousButton => MaterialButton(
            minWidth: 24,
            onPressed: cubit.onPrevButtonPressed,
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              Icons.navigate_before,
              size: 24,
            ),
            padding: EdgeInsets.all(8),
            shape: CircleBorder());


  Widget get nextButton => MaterialButton(
            minWidth: 24,
            onPressed: cubit.onNextButtonPressed,
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              Icons.navigate_next,
              size: 24,
            ),
            padding: EdgeInsets.all(8),
            shape: CircleBorder());


  Widget get deleteButton =>
         MaterialButton(
            minWidth: 24,
            onPressed: cubit.showConfirmDeleteFile,
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              Icons.clear,
              size: 24,
            ),
            padding: EdgeInsets.all(8),
            shape: CircleBorder());


  Widget buildEmptyView() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildAddPhotoButton(), _buildTakePhotoButton()],
        ),
      );

  //PageController pageController = PageController();

  Widget _buildPageView(ImagesPreviewData data) {
    return Container(
          child: Stack(
            children: [
              PageView.builder(
                controller: cubit.pageController,
                itemBuilder: (context, position) {
                  return createPage(data.items[position]);
                },
                itemCount: data.items.length,
                onPageChanged: cubit.onPageChanged,
              ),

              Align(alignment: Alignment.centerLeft, child: Visibility(visible: data.selectedPosition >0, child: previousButton)),
              Align(alignment: Alignment.centerRight, child: Visibility(visible: data.selectedPosition < data.items.length - 1, child: nextButton)),
              Align(alignment: Alignment.bottomRight, child: deleteButton)
            ],
          ));
  }

  Widget createPage(String path) {
    return Container(
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            image: DecorationImage(
                image: FileImage(File(path)), fit: BoxFit.contain)));
  }

  Widget _buildTopView(ImagesPreviewData data) {
    return Container(
        height: 250,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child: data.items.isEmpty ? buildEmptyView() : _buildPageView(data),
      );
  }

  Widget _buildBottomView(ImagesPreviewData data) {
    return  Container(
        height: 120,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child: Row(
          children: [
            Expanded(child: ListView.builder(
                itemBuilder: (context, position) {
                  return GestureDetector(onTap: () => cubit.onListViewItemPressed(position),child:  Container(
                      margin: EdgeInsets.only(left: 4, right: 4),
                      width: 80,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          border: position == data.selectedPosition ? Border.all(color: Colors.blue) : null,
                          image: DecorationImage(
                              image: FileImage(File(data.items[position])), fit: BoxFit.contain))
                  ));
                },
                itemCount: data.items.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true)),
             Column(mainAxisAlignment: MainAxisAlignment.center,children: [_buildAddPhotoButton(), _buildTakePhotoButton()])
          ],
        ),
      );
  }

}
