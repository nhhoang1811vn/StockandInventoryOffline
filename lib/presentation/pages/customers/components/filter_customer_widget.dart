import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/customers_setting.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/domain/entities/goods_setting.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/payment/components/text_selection.dart';
import 'package:good_manager/presentation/widgets/outline_button.dart';

import '../../../widgets/primary_button.dart';


class FilterCustomerWidget extends StatefulWidget{
  final void Function() onResetAllPressed;
  final void Function(CustomersSetting setting) onApplyPressed;
  final CustomersSetting setting;
  FilterCustomerWidget({
    required this.onResetAllPressed,
    required this.onApplyPressed,
    required this.setting
  });

  @override
  State<StatefulWidget> createState() {
    return FilterCustomerWidgetState();
  }
}
class FilterCustomerWidgetState extends State<FilterCustomerWidget>{
  SortByText _sortByName = SortByText.no_sort;

  @override
  void initState() {
    super.initState();
    _sortByName = widget.setting.sortByName;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(AppLocalizations.of(context)!.title_filter,
                style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.sort_by_name, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          buildSortByNameOptions(),
          SizedBox(height: 16),
          Row(children: [
            Expanded(child: MyOutlineButton(AppLocalizations.of(context)!.action_reset_all, () {
              widget.onResetAllPressed();
            }),),
            SizedBox(width: 16),
            Expanded(child: PrimaryButton(AppLocalizations.of(context)!.action_apply, () {
              widget.onApplyPressed(
                  widget.setting.copyWith(
                      sortByName : _sortByName
                  //    isPaid: _isPaid
                  )
              );
            }),)
          ],)

        ],
      ),
    );
  }
  Widget buildSortByNameOptions(){
    List<Widget> items = [];
    for (var item in SortByText.values){
      items.add(AppTextSelection(item: item.getText(context), isSelected: _sortByName == item, onPressed: (){
        setState(() {
          _sortByName = item;
        });
      }));
    }
    return Wrap(spacing: 8, runSpacing: 8, children: items);
  }
}