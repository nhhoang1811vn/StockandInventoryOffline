import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/login/components/build_divider.dart';

class SigninWithGoogleText extends StatelessWidget {
  const SigninWithGoogleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        BuildDivider.buildDivider(),
        Gap(4),
        Text(
            AppLocalizations.of(context)!.or_sign_in_with,
          //style: TextStyles.font13Grey400Weight,
        ),
        Gap(4),
        BuildDivider.buildDivider(),
      ],
    );
  }
}