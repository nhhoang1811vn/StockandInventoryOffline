import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/pages.dart';


class DoNotHaveAccountText extends StatelessWidget {
  const DoNotHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Pages.signup);
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context)!.dont_have_an_account_yet,
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: ' ' + AppLocalizations.of(context)!.sign_up_text,
              style: TextStyle(color: Color(0xFF2661FA)),
              //style: TextStyles.font11Blue600Weight,
            ),
          ],
        ),
      ),
    );
  }
}