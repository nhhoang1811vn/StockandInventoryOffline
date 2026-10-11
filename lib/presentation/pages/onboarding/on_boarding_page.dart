import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../di/di.dart';
import '../pages.dart';
import 'bloc/on_boarding_cubit.dart';

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final OnBoardingCubit cubit = getIt<OnBoardingCubit>();
  late final TextEditingController _storeNameController;

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_storeNameController.text.isEmpty) {
      final defaultName = context.tr("default_store_name");
      _storeNameController.text = defaultName;
      cubit.nameChanged(defaultName);
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final background = theme.scaffoldBackgroundColor;

    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: -0.4,
      height: 1.2,
      color: colors.onSurface,
    );

    final bodyStyle = theme.textTheme.bodyLarge?.copyWith(
      height: 1.5,
      color: colors.onSurface.withValues(alpha: 0.62),
    );

    final pageDecoration = PageDecoration(
      pageColor: background,
      imagePadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      bodyPadding: EdgeInsets.zero,
      contentMargin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      bodyAlignment: Alignment.center,
      imageFlex: 0,
      bodyFlex: 1,
    );

    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            Navigator.of(context).pushReplacementNamed(Pages.main);
          } else if (state.status.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.tr("store_create_failed"))),
            );
          }
        },
        child: Scaffold(
          backgroundColor: background,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: IntroductionScreen(
              key: introKey,
              globalBackgroundColor: background,
              animationDuration: 350,
              controlsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              pages: [
                _contentPage(
                  title: context.tr("on_boarding_title_1"),
                  body: context.tr("on_boarding_content_1"),
                  assetPath: "assets/images/onboarding_store.png",
                  titleStyle: titleStyle,
                  bodyStyle: bodyStyle,
                  colors: colors,
                  decoration: pageDecoration,
                ),
                _contentPage(
                  title: context.tr("on_boarding_title_2"),
                  body: context.tr("on_boarding_content_2"),
                  assetPath: "assets/images/app_logo.png",
                  titleStyle: titleStyle,
                  bodyStyle: bodyStyle,
                  colors: colors,
                  decoration: pageDecoration,
                ),
                _contentPage(
                  title: context.tr("on_boarding_title_3"),
                  body: context.tr("on_boarding_content_3"),
                  assetPath: "assets/images/onboarding_document.png",
                  titleStyle: titleStyle,
                  bodyStyle: bodyStyle,
                  colors: colors,
                  decoration: pageDecoration,
                ),
                _contentPage(
                  title: context.tr("on_boarding_title_4"),
                  body: context.tr("on_boarding_header_4"),
                  assetPath: "assets/images/onboarding_store.png",
                  titleStyle: titleStyle,
                  bodyStyle: bodyStyle,
                  colors: colors,
                  decoration: pageDecoration,
                  extra: _StoreNameField(
                    controller: _storeNameController,
                    hintText: context.tr("hint_store_name"),
                    onChanged: cubit.nameChanged,
                    onSubmitted: (_) => cubit.onAddStore(),
                  ),
                ),
              ],
              onDone: cubit.onAddStore,
              showSkipButton: true,
              skip: Text(
                context.tr("skip"),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              next: _CircleAction(
                color: colors.primary,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: colors.onPrimary,
                ),
              ),
              done: _DoneAction(
                label: context.tr("done"),
                color: colors.primary,
                onColor: colors.onPrimary,
              ),
              dotsDecorator: DotsDecorator(
                size: const Size(8, 8),
                color: colors.primary.withValues(alpha: 0.18),
                activeColor: colors.primary,
                activeSize: const Size(22, 8),
                spacing: const EdgeInsets.symmetric(horizontal: 4),
                activeShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageViewModel _contentPage({
    required String title,
    required String body,
    required String assetPath,
    required TextStyle? titleStyle,
    required TextStyle? bodyStyle,
    required ColorScheme colors,
    required PageDecoration decoration,
    Widget? extra,
  }) {
    return PageViewModel(
      titleWidget: const SizedBox.shrink(),
      decoration: decoration,
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Illustration(assetPath: assetPath, colors: colors),
            const SizedBox(height: 36),
            Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            const SizedBox(height: 12),
            Text(
              body,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
            if (extra != null) ...[
              const SizedBox(height: 28),
              extra,
            ],
          ],
        ),
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  final String assetPath;
  final ColorScheme colors;

  const _Illustration({
    required this.assetPath,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 188,
      height: 188,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _StoreNameField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _StoreNameField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.surface,
        hintText: hintText,
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: colors.onSurface.withValues(alpha: 0.35),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colors.outline.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );
  }
}

class _CircleAction extends StatelessWidget {
  final Color color;
  final Widget child;

  const _CircleAction({
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}

class _DoneAction extends StatelessWidget {
  final String label;
  final Color color;
  final Color onColor;

  const _DoneAction({
    required this.label,
    required this.color,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: onColor,
          fontSize: 15,
        ),
      ),
    );
  }
}
