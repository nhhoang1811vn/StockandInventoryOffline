import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/widget/images_preview/images_preview_state.dart';

import '../../dialog/dialog.dart';
import '../../pages/pages.dart';
import '../circle_button_widget.dart';
import 'images_preview_cubit.dart';

class ImagesPreviewView extends StatefulWidget {
  final List<Uint8List> items;
  final bool multipleImages;
  final Function(List<Uint8List>) onDataChanged;

  ImagesPreviewView(this.items, this.multipleImages, this.onDataChanged)
      : super();

  @override
  State<StatefulWidget> createState() {
    return ImagesPreviewViewState();
  }
}

class ImagesPreviewViewState extends State<ImagesPreviewView> {
  ImagesPreviewCubit cubit = ImagesPreviewCubit();

  @override
  void initState() {
    super.initState();
    cubit.initState(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => cubit, child: _buildBody());
  }

  Widget _buildBody() {
    return BlocConsumer<ImagesPreviewCubit, ImagesPreviewData>(
      listenWhen: (state1, state2) => state1.state != state2.state,
      listener: (context, state) async {
        if (state.state is TransitionPageViewState) {
          pageController.animateToPage(
            state.selectedPosition,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }
        if (state.state is DataChangedState) {
          widget.onDataChanged(state.items);
        } else if (state.state is TakePictureState) {
          final result =
              await Navigator.of(context).pushNamed(Pages.take_picture);
          if (result != null) {
            cubit.onAddPhoto(result as String);
          }
        } else if (state.state is ShowDeletePopupState) {
          showCustomAlertDialog(
            context,
            message:
                AppLocalizations.of(context)!.message_confirm_delete_no_args,
            onPositivePressed: () async {
              hideDialog(context);
              cubit.onDeleteItem();
            },
          );
        }
      },
      builder: (context, data) => Column(
        children: [
          _buildTopView(data),
          SizedBox(height: 8),
          if (data.items.isNotEmpty && widget.multipleImages)
            _buildBottomView(data),
        ],
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return CircleButton(Icons.add_photo_alternate, cubit.onAddPhotoPressed);
  }

  Widget _buildTakePhotoButton() {
    return CircleButton(Icons.add_a_photo, cubit.onTakePhotoPressed);
  }

  Widget get previousButton =>
      CircleButton(Icons.navigate_before, cubit.onPrevButtonPressed);

  Widget get nextButton =>
      CircleButton(Icons.navigate_next, cubit.onNextButtonPressed);

  Widget get deleteButton =>
      CircleButton(Icons.clear, cubit.onDeleteButtonClicked);

  Widget buildEmptyView() => Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildAddPhotoButton(), _buildTakePhotoButton()],
        ),
      );

  PageController pageController = PageController();

  Widget _buildPageView(ImagesPreviewData data) {
    return Container(
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemBuilder: (context, position) {
              return createPage(data.items[position]);
            },
            itemCount: data.items.length,
            onPageChanged: cubit.onPageChanged,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Visibility(
              visible: data.selectedPosition > 0,
              child: previousButton,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Visibility(
              visible: data.selectedPosition < data.items.length - 1,
              child: nextButton,
            ),
          ),
          Align(alignment: Alignment.bottomRight, child: deleteButton),
        ],
      ),
    );
  }

  Widget createPage(Uint8List bytes) {
    return Image.memory(bytes);
  }

  Widget _buildTopView(ImagesPreviewData data) {
    return Container(
      height: 250,
      child: data.items.isEmpty ? buildEmptyView() : _buildPageView(data),
    );
  }

  Widget _buildBottomView(ImagesPreviewData data) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(border: Border.all(color: Color(0xFF616161))),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () => cubit.onListViewItemPressed(position),
                  child: Container(
                    margin: EdgeInsets.only(left: 4, right: 4),
                    width: 80,
                    alignment: Alignment.center,
                    child: Image.memory(data.items[position]),
                    decoration: BoxDecoration(
                      border: position == data.selectedPosition
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                  ),
                );
              },
              itemCount: data.items.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildAddPhotoButton(), _buildTakePhotoButton()],
          ),
        ],
      ),
    );
  }
}
