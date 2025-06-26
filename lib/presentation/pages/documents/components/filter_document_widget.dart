import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/payment/components/text_selection.dart';
import 'package:good_manager/presentation/widgets/outline_button.dart';

import '../../../widgets/primary_button.dart';


class FilterDocumentWidget extends StatefulWidget{
  final void Function() onResetAllPressed;
  final void Function(DocumentsSetting setting) onApplyPressed;
  final DocumentsSetting setting;
  FilterDocumentWidget({
    required this.onResetAllPressed,
    required this.onApplyPressed,
    required this.setting
  });

  @override
  State<StatefulWidget> createState() {
    return FilterDocumentWidgetState();
  }
}
class FilterDocumentWidgetState extends State<FilterDocumentWidget>{
  bool? _isPaid;
  @override
  void initState() {
    super.initState();
    _isPaid = widget.setting.isPaid;

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.title_filter,
              style: Theme.of(context).textTheme.titleLarge),
          _buildByStatusWidget(),
          SizedBox(height: 16),
          Row(children: [
            Expanded(child: MyOutlineButton(AppLocalizations.of(context)!.action_reset_all, () {
              widget.onResetAllPressed();
            }),),
            SizedBox(width: 16),
            Expanded(child: PrimaryButton(AppLocalizations.of(context)!.action_apply, () {
              widget.onApplyPressed(
                  widget.setting.copyWith(isPaid: _isPaid)
              );
            }),)
          ],)

        ],
      ),
    );
  }
  Widget _buildByStatusWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(AppLocalizations.of(context)!.by_status,
          style: Theme.of(context).textTheme.titleMedium),
      SizedBox(height: 8),
      Row(children: [
        Expanded(
          child: SizedBox(height: 40,
            child: AppTextSelection(item: AppLocalizations.of(context)!.show_all, isSelected: _isPaid == null, onPressed: (){
              setState(() {
                _isPaid = null;
              });
            }),
          ),
        ),
        SizedBox(width: 8,),
        Expanded(
          child: SizedBox(height: 40,
            child: AppTextSelection(item: AppLocalizations.of(context)!.status_paid, isSelected: _isPaid == true, onPressed: (){
              setState(() {
                _isPaid = true;
              });
            }),
          ),
        ),
        SizedBox(width: 8,),
        Expanded(
          child: SizedBox(height: 40,
            child: AppTextSelection(item: AppLocalizations.of(context)!.status_unpaid, isSelected: _isPaid == false, onPressed: (){
              setState(() {
                _isPaid = false;
              });
            }),
          ),
        ),
      ],)
    ],);
  }
}