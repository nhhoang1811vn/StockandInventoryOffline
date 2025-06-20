import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/entities/payments_setting.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/payment/components/text_selection.dart';
import 'package:good_manager/presentation/pages/payment/components/wallet_selection.dart';
import 'package:good_manager/presentation/widgets/outline_button.dart';

import '../../../widgets/primary_button.dart';
import 'category_selection.dart';

class FilterPaymentWidget extends StatefulWidget{
  final void Function() onResetAllPressed;
  final List<PaymentCategory?> categories;
  final List<Wallet> wallets;
  final List<Customer> customers;
  final List<Supplier> suppliers;
  final void Function(PaymentsSetting setting) onApplyPressed;
  final PaymentsSetting setting;
  FilterPaymentWidget({
    required this.onResetAllPressed,
    required this.categories,
    required this.wallets,
    required this.customers,
    required this.suppliers,
    required this.onApplyPressed,
    required this.setting
  });

  @override
  State<StatefulWidget> createState() {
    return FilterPaymentWidgetState();
  }
}
class FilterPaymentWidgetState extends State<FilterPaymentWidget>{
  Set<int?> _selectedCategoryIds = {};
  Set<int> _selectedWalletIds = {};
  Set<int> _selectedCustomerIds = {};
  Set<int> _selectedSupplierIds = {};


  DateTime? _startDate;
  DateTime? _endDate;

  DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  @override
  void initState() {
    super.initState();
    _selectedCategoryIds = Set<int?>.of(widget.setting.selectedCategoryIds);
    _selectedWalletIds = Set<int>.of(widget.setting.selectedWalletIds);
    _selectedCustomerIds = Set<int>.of(widget.setting.selectedCustomerIds);
    _selectedSupplierIds = Set<int>.of(widget.setting.selectedSupplierIds);
    _startDate = widget.setting.startDate;
    _endDate = widget.setting.endDate;
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
          Text(AppLocalizations.of(context)!.by_category,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          buildCategoriesGridView(widget.categories),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.by_wallet, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          buildWalletsGridView(widget.wallets),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.by_customer,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          buildCustomersGridView(widget.customers),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.by_supplier,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          buildSuppliersGridView(widget.suppliers),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.by_date,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          buildDatesWidget(),
          SizedBox(height: 16),
          Row(children: [
            Expanded(child: MyOutlineButton(AppLocalizations.of(context)!.action_reset_all, () {
              widget.onResetAllPressed();
            }),),
            SizedBox(width: 16),
            Expanded(child: PrimaryButton(AppLocalizations.of(context)!.action_apply, () {
              widget.onApplyPressed(
                  widget.setting.copyWith(
                      selectedCategoryIds: _selectedCategoryIds,
                      selectedWalletIds: _selectedWalletIds,
                      selectedCustomerIds: _selectedCustomerIds,
                      selectedSupplierIds: _selectedSupplierIds,
                      startDate: _startDate,
                      endDate: _endDate
                  )
              );
            }),)
          ],)

        ],
      ),
    );
  }

  Widget buildCategoriesGridView(List<PaymentCategory?> categories){
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1
        ),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0)
            return AppTextSelection(item: AppLocalizations.of(context)!.show_all, isSelected: _selectedCategoryIds.isEmpty, onPressed: (){
              setState(() {
                _selectedCategoryIds = {};
              });
            });
          var item = categories[index - 1];
          if (item != null){
            return CategorySelection(
                item: item,
                isSelected: _selectedCategoryIds.contains(item.id),
                onPressed: () {
                  setState(() {
                    if (_selectedCategoryIds.contains(item.id)){
                      _selectedCategoryIds.remove(item.id);
                    }else{
                      _selectedCategoryIds.add(item.id);
                    }
                    //_selectedCategoryId = item.id;
                  });
                });
          }else{
            return AppTextSelection(
                item: AppLocalizations.of(context)!.no_category,
                isSelected: _selectedCategoryIds.contains(item?.id),
                onPressed: (){
                  setState(() {
                    if (_selectedCategoryIds.contains(item?.id)){
                      _selectedCategoryIds.remove(item?.id);
                    }else{
                      _selectedCategoryIds.add(item?.id);
                    }
                  });
                });
          }

        });
  }
  Widget buildWalletsGridView(List<Wallet> items){
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1
        ),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0)
            return AppTextSelection(item: AppLocalizations.of(context)!.show_all, isSelected: _selectedWalletIds.isEmpty, onPressed: (){
              setState(() {
                _selectedWalletIds = {};
              });
            });
          var item = items[index - 1];
          return WalletSelection(
              item: items[index - 1],
              isSelected: _selectedWalletIds.contains(items[index - 1].id),
              showBalance: true,
              onPressed: () {
                setState(() {
                  if (_selectedWalletIds.contains(item.id)){
                    _selectedWalletIds.remove(item.id);
                  }else{
                    _selectedWalletIds.add(item.id!);
                  }
                });
              });
        });
  }
  Widget buildCustomersGridView(List<Customer> items){
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.5
        ),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0)
            return AppTextSelection(item: AppLocalizations.of(context)!.show_all, isSelected: _selectedCustomerIds.isEmpty, onPressed: (){
              setState(() {
                _selectedCustomerIds = {};
              });
            });
          var item = items[index - 1];
          return AppTextSelection(item: item.name, isSelected: _selectedCustomerIds.contains(item.id), onPressed: (){
            setState(() {
              if (_selectedCustomerIds.contains(item.id)){
                _selectedCustomerIds.remove(item.id);
              }else{
                _selectedCustomerIds.add(item.id!);
              }
            });
          });
        });
  }
  Widget buildSuppliersGridView(List<Supplier> items){
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.5
        ),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0)
            return AppTextSelection(item: AppLocalizations.of(context)!.show_all, isSelected: _selectedSupplierIds.isEmpty, onPressed: (){
              setState(() {
                _selectedSupplierIds = {};
              });
            });
          var item = items[index - 1];
          return AppTextSelection(item: item.name, isSelected: _selectedSupplierIds.contains(item.id), onPressed: (){
            setState(() {
              if (_selectedSupplierIds.contains(item.id)){
                _selectedSupplierIds.remove(item.id);
              }else{
                _selectedSupplierIds.add(item.id!);
              }
            });
          });
        });
  }
  Widget buildDatesWidget(){
    var isSelectedShowAll = (_startDate == null || _endDate == null);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: SizedBox(height: 40,child: AppTextSelection(item: AppLocalizations.of(context)!.show_all, isSelected: isSelectedShowAll, onPressed: (){
              setState(() {
                _startDate = null;
                _endDate = null;
              });
            }))),
            SizedBox(width: 8,),
            Expanded(child: SizedBox(height: 40,child: AppTextSelection(item: AppLocalizations.of(context)!.report_type_custom, isSelected: !isSelectedShowAll, onPressed: (){
              setState(() {
                _startDate = DateTime.now();
                _endDate = DateTime.now();
              });
            }))),
          ],
        ),
        if (!isSelectedShowAll)

          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Row(children: [
                  Expanded(child: Text(AppLocalizations.of(context)!.start_date)),
                  SizedBox(width: 8,),
                  Expanded(child: Text(AppLocalizations.of(context)!.end_date))
                ],),
                SizedBox(height: 4),
                Row(children: [
                  Expanded(child: SizedBox(height: 40,child: AppTextSelection(item: DateFormatFactory.getDateFormat().format(_startDate!), isSelected: false, onPressed: (){
                    pickDateRange();
                  }))),
                  SizedBox(width: 8,),
                  Expanded(child: SizedBox(height: 40,child: AppTextSelection(item: DateFormatFactory.getDateFormat().format(_endDate!), isSelected: false, onPressed: (){
                    pickDateRange();
                  }))),
                ],),
              ],
            ),
          )
      ],
    );
  }

  Future pickDateRange() async{
    DateTimeRange? result = await showDateRangePicker(context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (result != null){
      setState(() {
        dateRange = result;
        _startDate = result.start;
        _endDate = result.end;

      });
    }
  }
}