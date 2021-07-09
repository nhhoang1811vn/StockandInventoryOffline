import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/data/repositories/data_store_repository.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'on_boarding_cotronller.dart';

class OnBoardingPage extends View {
  @override
  OnBoardingPageView createState() =>
      OnBoardingPageView(OnBoardingController(DataStoreRepository()));
}

class OnBoardingPageView
    extends ViewState<OnBoardingPage, OnBoardingController> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final OnBoardingController controller;
  final nameTextController = TextEditingController();
  bool _validate = true;

  OnBoardingPageView(this.controller) : super(controller);

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('images/$assetName.png', width: 200.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  void initState() {
    //nameTextController.text = AppLocalizations.of(context).main_store;
    super.initState();
  }

  @override
  Widget get view {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: globalKey,
      pages: [
        PageViewModel(
          title: AppLocalizations.of(context).on_boarding_title_1,
          body: AppLocalizations.of(context).on_boarding_content_1,
          image: _buildImage('inventory'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context).on_boarding_title_2,
          body: AppLocalizations.of(context).on_boarding_content_2,
          image: _buildImage('inventory'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context).on_boarding_title_3,
          body: AppLocalizations.of(context).on_boarding_content_3,
          image: _buildImage('inventory'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context).on_boarding_title_4,
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context).on_boarding_header_4,
                  style: bodyStyle),
              TextField(
                //initialValue: 'abc',
                controller: nameTextController,
                onChanged: (value) {
                  setState(() {
                    value.isEmpty ? _validate = false : _validate = true;
                  });
                },
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).field_name),
              ),
            ],
          ),
          image: _buildImage('inventory'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => controller.onAddStore(nameTextController.text),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text(AppLocalizations.of(context).action_skip),
      next: const Icon(Icons.arrow_forward),
      done: Visibility(
        visible: _validate,
        child: Text(AppLocalizations.of(context).action_done,
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),

      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
