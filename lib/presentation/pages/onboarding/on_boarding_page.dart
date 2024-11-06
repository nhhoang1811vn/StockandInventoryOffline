import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import 'package:good_manager/common/helpers/injection.container.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../pages.dart';
import 'bloc/on_boarding_cubit.dart';

class OnBoardingPage extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();
  final OnBoardingCubit cubit = getIt<OnBoardingCubit>();

  @override
  Widget build(BuildContext context){
    const bodyStyle = TextStyle(fontSize: 18.0);
    const pageDecoration =  PageDecoration(
      imagePadding : EdgeInsets.only(bottom: 48.0),
      titlePadding: EdgeInsets.only(bottom: 20.0, top: 120.0),
      //pageMargin: EdgeInsets.only(bottom: 48.0),
      //pageMargin:  EdgeInsets.only(bottom: 0.0),
      titleTextStyle: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      //imagePadding: EdgeInsets.zero,
    );
    return BlocProvider(create: (context) => cubit, child: BlocConsumer<OnBoardingCubit, OnBoardingState>(listener: (context, state){
      if (state.status.isFailure) {
        //ScaffoldMessenger.of(context)
        //    .showSnackBar(snackBarWhenFailureWithText(state.exceptionError));
        Navigator.of(context).pushReplacementNamed(Pages.home);
      } else if (state.status.isSuccess) {
        Navigator.of(context).pushReplacementNamed(Pages.home);
      }
    },builder: (context, state) => IntroductionScreen(
      //key: globalKey,
      pages: [
        PageViewModel(
          title: AppLocalizations.of(context)!.on_boarding_title_1,
          body: AppLocalizations.of(context)!.on_boarding_content_1,
          image: Container(width: 150.0,
              height: 150.0,
              padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.blue),
            shape: BoxShape.circle,
          ),child: Image.asset(
            "assets/images/onboarding_store.png",
          )),
          //image: Image.asset(name)
          //image: Icon(UIConstants.storeIconData, size: 60, color: AppColors.primaryColor,),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.on_boarding_title_2,
          body: AppLocalizations.of(context)!.on_boarding_content_2,
          image: Container(width: 150.0,
              height: 150.0,
              padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.blue),
                shape: BoxShape.circle,
              ),child: Image.asset(
                "assets/images/onboarding_good.png",
              )),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.on_boarding_title_3,
          body: AppLocalizations.of(context)!.on_boarding_content_3,
          image: Container(width: 150.0,
              height: 150.0,
              padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.blue),
                shape: BoxShape.circle,
              ),child: Image.asset(
                "assets/images/onboarding_document.png",
              )),
          decoration: pageDecoration,
        ),
        PageViewModel(
            image: Container(width: 150.0,
                height: 150.0,
                padding: EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.blue),
                  shape: BoxShape.circle,
                ),child: Image.asset(
                  "assets/images/onboarding_store.png",
                )),
          title: AppLocalizations.of(context)!.on_boarding_title_4,
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.on_boarding_header_4,
                  style: bodyStyle),
              TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Main Store",
                ),
                onChanged: context.read<OnBoardingCubit>().nameChanged,
                //decoration: InputDecoration(
                //    labelText: AppLocalizations.of(context)!.field_name),
              ),
            ],
          ),
          //image: Icon(UIConstants.storeIconData, size: 60, color: AppColors.primaryColor),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => context.read<OnBoardingCubit>().onAddStore(),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      //skipFlex: 0,
      nextFlex: 0,
      skip: Text(AppLocalizations.of(context)!.action_skip),
      next: const Icon(Icons.arrow_forward),
      done: Visibility(
        visible: state.name.trim().isNotEmpty,
        child: Text(AppLocalizations.of(context)!.action_done,
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
    )));
  }
}
