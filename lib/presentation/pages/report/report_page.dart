import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart';
import 'package:good_manager/presentation/pages/report/report_date_range_type.dart';
import 'package:good_manager/presentation/pages/report/report_range_selection.dart';

import '../../../domain/entity/entity.dart';
import '../pages.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReportPageState();
  }
}

class ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<ReportCubit, ReportState>(
      builder: (context, state) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            context.tr("report_title"),
            style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800),
          ),
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        ),
        body: _buildBody(),
      ),
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {},
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
      children: [
        _buildSectionHeader(context.tr("sales_title"), showNewTag: true),
        _buildReportGroup([
          ReportType.SALES_BY_DATE,
          ReportType.SALES_BY_ITEM,
          ReportType.SALES_BY_CUSTOMER,
        ]),
        _buildSectionHeader(context.tr("inventory")),
        _buildReportGroup([
          ReportType.LIST_OF_GOODS,
          ReportType.RE_ORDER,
          ReportType.GOOD_INFO,
          ReportType.LIST_OF_DOCUMENT,
        ]),
        _buildSectionHeader(context.tr("payments_title")),
        _buildReportGroup([
          ReportType.INBOUND_PAYMENTS,
          ReportType.OUTBOUND_PAYMENTS,
          ReportType.LIST_OF_WALLETS,
        ]),
        _buildSectionHeader(context.tr("person_name")),
        _buildReportGroup([
          ReportType.DEBTS_BY_SUPPLIER,
          ReportType.DEBTS_BY_CUSTOMER,
          ReportType.LIST_OF_SUPPLIER_PAYMENTS,
          ReportType.LIST_OF_CUSTOMER_PAYMENTS,
        ]),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool showNewTag = false}) {
    final theme = Theme.of(context);
    final titleText = Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        letterSpacing: 1.2,
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12, top: 24),
      child: showNewTag
          ? Row(
              children: [
                titleText,
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    context.tr("tag_new"),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            )
          : titleText,
    );
  }

  Widget _buildReportGroup(List<ReportType> types) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: List.generate(types.length, (index) {
            final type = types[index];
            final isLast = index == types.length - 1;
            return _buildReportItem(type, isLast);
          }),
        ),
      ),
    );
  }

  Widget _buildReportItem(ReportType type, bool isLast) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconForReportType(type),
              color: theme.colorScheme.primary,
              size: 22,
            ),
          ),
          title: Text(
            type.getTitle(context),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: theme.colorScheme.onSurface,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          onTap: () => onReportTypeTapped(type),
        ),
        if (!isLast)
          Divider(
            height: 0,
            indent: 60,
            color: theme.dividerColor.withValues(alpha: 0.05),
          ),
      ],
    );
  }

  IconData _getIconForReportType(ReportType type) {
    switch (type) {
      case ReportType.LIST_OF_GOODS:
        return Icons.inventory_2_outlined;
      case ReportType.LIST_OF_DOCUMENT:
        return Icons.receipt_long_outlined;
      case ReportType.DEBTS_BY_SUPPLIER:
        return Icons.person_remove_outlined;
      case ReportType.DEBTS_BY_CUSTOMER:
        return Icons.person_add_outlined;
      case ReportType.OUTBOUND_PAYMENTS:
        return Icons.file_upload_outlined;
      case ReportType.INBOUND_PAYMENTS:
        return Icons.file_download_outlined;
      case ReportType.LIST_OF_WALLETS:
        return Icons.account_balance_wallet_outlined;
      case ReportType.LIST_OF_SUPPLIER_PAYMENTS:
        return Icons.upload_file_outlined;
      case ReportType.LIST_OF_CUSTOMER_PAYMENTS:
        return Icons.download_done_outlined;
      case ReportType.RE_ORDER:
        return Icons.reorder_outlined;
      case ReportType.GOOD_INFO:
        return Icons.info_outline;
      case ReportType.SALES_BY_DATE:
        return Icons.point_of_sale;
      case ReportType.SALES_BY_ITEM:
        return Icons.category_outlined;
      case ReportType.SALES_BY_CUSTOMER:
        return Icons.people_outline;
    }
  }

  void onReportTypeTapped(ReportType reportType) async {
    if (reportType == ReportType.RE_ORDER) {
      onReportReorder(context);
    } else if (reportType == ReportType.GOOD_INFO) {
      Navigator.of(context).pushNamed(
        Pages.report_detail,
        arguments: {
          'type': ReportType.GOOD_INFO,
        },
      );
    } else {
      ReportRangeSelection? selection = await showSelectDateRangeType(
        context,
        showGroup: reportType == ReportType.SALES_BY_ITEM,
        showCustomer: reportType == ReportType.SALES_BY_CUSTOMER,
      );
      if (selection != null) {
        ReportDateRangeType reportDateRangeType = selection.type;
        DateTime? mStart;
        DateTime? mEnd;
        DateTime now = DateTime.now();
        DateTime tmr = DateTime(now.year, now.month, now.day + 1);
        if (reportDateRangeType == ReportDateRangeType.CUSTOM) {
          DateTimeRange? range = await pickDateRange();
          if (range != null) {
            mStart = range.start;
            mEnd = range.end;
          }
        } else {
          switch (reportDateRangeType) {
            case ReportDateRangeType.CURRENT_MONTH:
              mStart = DateTime(now.year, now.month, 1);
              mEnd = tmr.subtract(Duration(seconds: 1));
              break;
            case ReportDateRangeType.LAST_30_DAYS:
              mStart = DateTime(now.year, now.month, now.day - 30);
              mEnd = tmr.subtract(Duration(seconds: 1));
              break;
            case ReportDateRangeType.LAST_90_DAYS:
              mStart = DateTime(now.year, now.month, now.day - 90);
              mEnd = tmr.subtract(Duration(seconds: 1));
              break;
            case ReportDateRangeType.CURRENT_YEAR:
              mStart = DateTime(now.year, 1, 1);
              mEnd = tmr.subtract(Duration(seconds: 1));
              break;
            default:
              ;
          }
        }
        if (mStart != null && mEnd != null) {
          Navigator.of(context).pushNamed(
            Pages.report_detail,
            arguments: {
              'type': reportType,
              'start': mStart,
              'end': mEnd,
              'groupId': selection.groupId,
              'customerId': selection.customerId,
            },
          );
        }
      }
    }
  }

  void onReportReorder(BuildContext context) async {
    Navigator.of(context).pushNamed(
      Pages.report_detail,
      arguments: {
        'type': ReportType.RE_ORDER,
      },
    );
  }

  Future<ReportRangeSelection?> showSelectDateRangeType(
    BuildContext context, {
    bool showGroup = false,
    bool showCustomer = false,
  }) async {
    final theme = Theme.of(context);
    int? groupId;
    String? groupName;
    int? customerId;
    String? customerName;
    return await showModalBottomSheet<ReportRangeSelection>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr("select_date_range"),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.4)),
                      ),
                    ],
                  ),
                ),
                if (showGroup)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(
                      context.tr("group"),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          groupName ?? context.tr("all"),
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.2)),
                      ],
                    ),
                    onTap: () async {
                      final result = await Navigator.of(context).pushNamed(
                        Pages.select_group,
                        arguments: {"groupId": groupId},
                      );
                      if (result == null) return;
                      final map = result as Map<dynamic, dynamic>;
                      setSheetState(() {
                        groupId = map["groupId"] as int?;
                        groupName = groupId == null
                            ? null
                            : map["groupName"] as String?;
                      });
                    },
                  ),
                if (showCustomer)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(
                      context.tr("customer"),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          customerName ?? context.tr("all"),
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.2)),
                      ],
                    ),
                    onTap: () async {
                      final result = await Navigator.of(context).pushNamed(
                        Pages.customer_list,
                        arguments: {"isSelection": true},
                      );
                      if (result is! Customer) return;
                      setSheetState(() {
                        customerId = result.id;
                        customerName = result.name;
                      });
                    },
                  ),
                ...ReportDateRangeType.values.map(
                  (type) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(
                      type.getText(context),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () => Navigator.pop(
                        context,
                        ReportRangeSelection(type,
                            groupId: groupId, customerId: customerId)),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<DateTimeRange?> pickDateRange() async {
    DateTimeRange dateRange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    return result;
  }
}
