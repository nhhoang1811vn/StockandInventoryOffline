import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/payment/components/text_selection.dart';
import 'package:good_manager/presentation/widget/widget.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';

class FilterPaymentWidget extends StatefulWidget {
  final Function() onResetAllPressed;
  final List<PaymentCategory?> categories;
  final List<Wallet> wallets;
  final List<Customer> customers;
  final List<Supplier> suppliers;
  final Function(PaymentsSetting setting) onApplyPressed;
  final PaymentsSetting setting;

  const FilterPaymentWidget({
    super.key,
    required this.onResetAllPressed,
    required this.categories,
    required this.wallets,
    required this.customers,
    required this.suppliers,
    required this.onApplyPressed,
    required this.setting,
  });

  @override
  State<StatefulWidget> createState() {
    return FilterPaymentWidgetState();
  }
}

class FilterPaymentWidgetState extends State<FilterPaymentWidget> {
  bool _sortByDateNewestFirst = true;
  Set<int?> _selectedCategoryIds = {};
  Set<int> _selectedWalletIds = {};
  Set<int> _selectedCustomerIds = {};
  Set<int> _selectedSupplierIds = {};

  DateTime? _startDate;
  DateTime? _endDate;

  DateTimeRange dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  void initState() {
    super.initState();
    _sortByDateNewestFirst = widget.setting.sortByDateNewestFirst;
    _selectedCategoryIds = Set<int?>.of(widget.setting.selectedCategoryIds);
    _selectedWalletIds = Set<int>.of(widget.setting.selectedWalletIds);
    _selectedCustomerIds = Set<int>.of(widget.setting.selectedCustomerIds);
    _selectedSupplierIds = Set<int>.of(widget.setting.selectedSupplierIds);
    _startDate = widget.setting.startDate;
    _endDate = widget.setting.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FilterSheetHeader(),
          FilterSectionTitle(context.tr("sort_by_date")),
          buildSortByDateOptions(),
          FilterSectionTitle(context.tr("by_category")),
          buildCategoriesOptions(widget.categories),
          FilterSectionTitle(context.tr("by_wallet")),
          buildWalletsOptions(widget.wallets),
          FilterSectionTitle(context.tr("by_customer")),
          buildCustomersOptions(widget.customers),
          FilterSectionTitle(context.tr("by_supplier")),
          buildSuppliersOptions(widget.suppliers),
          FilterSectionTitle(context.tr("by_date")),
          buildDatesWidget(),
          FilterSheetActions(
            onReset: widget.onResetAllPressed,
            onApply: () {
              widget.onApplyPressed(
                widget.setting.copyWith(
                  sortByDateNewestFirst: _sortByDateNewestFirst,
                      selectedCategoryIds: _selectedCategoryIds,
                      selectedWalletIds: _selectedWalletIds,
                      selectedCustomerIds: _selectedCustomerIds,
                      selectedSupplierIds: _selectedSupplierIds,
                      startDate: _startDate,
                      endDate: _endDate,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget buildSortByDateOptions() {
    List<Widget> items = [];
    items.add(
      AppTextSelection(
        item: context.tr("newest_to_oldest"),
        isSelected: _sortByDateNewestFirst,
        onPressed: () {
          setState(() {
            _sortByDateNewestFirst = true;
          });
        },
      ),
    );
    items.add(
      AppTextSelection(
        item: context.tr("oldest_to_newest"),
        isSelected: !_sortByDateNewestFirst,
        onPressed: () {
          setState(() {
            _sortByDateNewestFirst = false;
          });
        },
      ),
    );
    return FilterChipWrap(children: items);
  }

  Widget buildCategoriesOptions(List<PaymentCategory?> categories) {
    List<Widget> items = [];
    items.add(
      AppTextSelection(
        item: context.tr("show_all"),
        isSelected: _selectedCategoryIds.isEmpty,
        onPressed: () {
          setState(() {
            _selectedCategoryIds = {};
          });
        },
      ),
    );
    for (var category in categories) {
      items.add(
        AppTextSelection(
          icon: category == null
              ? null
              : Text(category.icon, style: TextStyle(fontSize: 20)),
          item: category == null
              ? context.tr("no_category")
              : category.name,
          isSelected: _selectedCategoryIds.contains(category?.id),
          onPressed: () {
            setState(() {
              if (_selectedCategoryIds.contains(category?.id)) {
                _selectedCategoryIds.remove(category?.id);
              } else {
                _selectedCategoryIds.add(category?.id);
              }
            });
          },
        ),
      );
    }
    return FilterChipWrap(children: items);
  }

  Widget buildWalletsOptions(List<Wallet> wallets) {
    List<Widget> items = [];
    items.add(
      AppTextSelection(
        item: context.tr("show_all"),
        isSelected: _selectedWalletIds.isEmpty,
        onPressed: () {
          setState(() {
            _selectedWalletIds = {};
          });
        },
      ),
    );
    for (var wallet in wallets) {
      items.add(
        AppTextSelection(
          icon: Icon(
            UIConstants.walletIconData,
            color: Color(wallet.color),
            size: 20,
          ),
          item: wallet.name,
          isSelected: _selectedWalletIds.contains(wallet.id),
          onPressed: () {
            setState(() {
              if (_selectedWalletIds.contains(wallet.id)) {
                _selectedWalletIds.remove(wallet.id);
              } else {
                _selectedWalletIds.add(wallet.id!);
              }
            });
          },
        ),
      );
    }
    return FilterChipWrap(children: items);
  }

  Widget buildCustomersOptions(List<Customer> customer) {
    List<Widget> items = [];
    items.add(
      AppTextSelection(
        item: context.tr("show_all"),
        isSelected: _selectedCustomerIds.isEmpty,
        onPressed: () {
          setState(() {
            _selectedCustomerIds = {};
          });
        },
      ),
    );
    for (var customer in customer) {
      items.add(
        AppTextSelection(
          item: customer.name,
          isSelected: _selectedCustomerIds.contains(customer.id),
          onPressed: () {
            setState(() {
              if (_selectedCustomerIds.contains(customer.id)) {
                _selectedCustomerIds.remove(customer.id);
              } else {
                _selectedCustomerIds.add(customer.id!);
              }
            });
          },
        ),
      );
    }
    return FilterChipWrap(children: items);
  }

  Widget buildSuppliersOptions(List<Supplier> suppliers) {
    List<Widget> items = [];
    items.add(
      AppTextSelection(
        item: context.tr("show_all"),
        isSelected: _selectedSupplierIds.isEmpty,
        onPressed: () {
          setState(() {
            _selectedSupplierIds = {};
          });
        },
      ),
    );
    for (var supplier in suppliers) {
      items.add(
        AppTextSelection(
          item: supplier.name,
          isSelected: _selectedSupplierIds.contains(supplier.id),
          onPressed: () {
            setState(() {
              if (_selectedSupplierIds.contains(supplier.id)) {
                _selectedSupplierIds.remove(supplier.id);
              } else {
                _selectedSupplierIds.add(supplier.id!);
              }
            });
          },
        ),
      );
    }
    return FilterChipWrap(children: items);
  }

  Widget buildDatesWidget() {
    var isSelectedShowAll = (_startDate == null || _endDate == null);
    return Column(
      children: [
        Row(
          children: [
            AppTextSelection(
              item: context.tr("show_all"),
              isSelected: isSelectedShowAll,
              onPressed: () {
                setState(() {
                  _startDate = null;
                  _endDate = null;
                });
              },
            ),
            SizedBox(
              width: 8,
            ),
            AppTextSelection(
              item: context.tr("report_type_custom"),
              isSelected: !isSelectedShowAll,
              onPressed: () {
                setState(() {
                  _startDate = DateTime.now();
                  _endDate = DateTime.now();
                });
              },
            ),
          ],
        ),
        if (!isSelectedShowAll)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(context.tr("start_date")),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(context.tr("end_date")),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: AppTextSelection(
                          item: DateFormatFactory.getDateFormat()
                              .format(_startDate!),
                          isSelected: false,
                          onPressed: () {
                            pickDateRange();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: AppTextSelection(
                          item: DateFormatFactory.getDateFormat()
                              .format(_endDate!),
                          isSelected: false,
                          onPressed: () {
                            pickDateRange();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future pickDateRange() async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      setState(() {
        dateRange = result;
        _startDate = result.start;
        _endDate = result.end;
      });
    }
  }
}
