import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/document_paid_status.dart';
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
  Set<DocumentPaidStatus> _selectedStatus = {};
  bool _sortByDateNewestFirst = true;
  @override
  void initState() {
    super.initState();
    _sortByDateNewestFirst = widget.setting.sortByDateNewestFirst;
    _selectedStatus = Set<DocumentPaidStatus>.of(widget.setting.selectedStatus);
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
          Text(AppLocalizations.of(context)!.sort_by_date, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          buildSortByDateOptions(),
          SizedBox(height: 16),
          _buildByStatusWidget(),
          SizedBox(height: 16),
          Row(children: [
            Expanded(child: MyOutlineButton(AppLocalizations.of(context)!.action_reset_all, () {
              widget.onResetAllPressed();
            }),),
            SizedBox(width: 16),
            Expanded(child: PrimaryButton(AppLocalizations.of(context)!.action_apply, () {
              widget.onApplyPressed(
                  widget.setting.copyWith(
                      sortByDateNewestFirst : _sortByDateNewestFirst,
                  selectedStatus: _selectedStatus
                  //    isPaid: _isPaid
                  )
              );
            }),)
          ],)

        ],
      ),
    );
  }
  Widget buildSortByDateOptions(){
    List<Widget> items = [];
    items.add(AppTextSelection(item: AppLocalizations.of(context)!.newest_to_oldest, isSelected: _sortByDateNewestFirst, onPressed: (){
      setState(() {
        _sortByDateNewestFirst = true;
      });
    }));
    items.add(AppTextSelection(item: AppLocalizations.of(context)!.oldest_to_newest, isSelected: !_sortByDateNewestFirst, onPressed: (){
      setState(() {
        _sortByDateNewestFirst = false;
      });
    }));
    return Wrap(spacing: 8, runSpacing: 8, children: items);
  }
  Widget _buildByStatusWidget(){
    List<Widget> items = [];
    items.add(AppTextSelection(item: AppLocalizations.of(context)!.show_all, isSelected: _selectedStatus.isEmpty, onPressed: (){
      setState(() {
        _selectedStatus = {};
      });
    }));
    for (var status in DocumentPaidStatus.values){
      items.add(AppTextSelection(item: status.getText(context), isSelected: _selectedStatus.contains(status), onPressed: (){
        setState(() {
          if (_selectedStatus.contains(status)){
            _selectedStatus.remove(status);
          }else{
            _selectedStatus.add(status);
          }
        });
      }));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(AppLocalizations.of(context)!.by_status,
          style: Theme.of(context).textTheme.titleMedium),
      SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8,children: items)
    ],);
  }
}