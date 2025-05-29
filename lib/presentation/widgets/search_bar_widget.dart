
import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';

class SearchBarWidget extends StatelessWidget{
  final TextEditingController controller;

  const SearchBarWidget({
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.hint_search_by,
        prefixIcon: Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty ? Icon(Icons.close) : null
      ),
    );
  }
}