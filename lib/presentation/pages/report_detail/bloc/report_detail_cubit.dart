import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/report_data/column_info.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../../constant/constant.dart';
import '../../../../data/app_settings.dart';
import '../../../../data/report_data/report_data_factory.dart';
import '../../../../data/report_data/utils.dart';
import '../../../../domain/entity/entity.dart';
import '../../base/base_state.dart';

part 'report_detail_cubit.freezed.dart';
part 'report_detail_state.dart';

sealed class ColumnReport {
  final String title;
  bool isVisible = true;
  bool showTotal = false;
  final bool isQuantity;

  ColumnReport({required this.title,
    this.isVisible = true,
    this.showTotal = false,
    this.isQuantity = false});
}

class SimpleColumn extends ColumnReport {
  SimpleColumn({
    required super.title,
    super.isVisible,
    super.showTotal,
    super.isQuantity,
  });
}

class PickableColumn extends ColumnReport {
  final Set<String> values;
  final Set<String> selectedValues;

  PickableColumn({
    required super.title,
    super.isVisible,
    super.showTotal,
    super.isQuantity,
    this.values = const {},
    this.selectedValues = const {},
  });
}

@injectable
class ReportDetailCubit extends Cubit<ReportDetailState> {
  final GoodsUseCases goodsUseCase;
  final DocumentUseCases documentUseCases;
  final SuppliersUseCase suppliersUseCase;
  final CustomersUseCase customersUseCase;
  final ReportDataFactory factory;

  ReportDetailCubit(
      {required this.factory,
      required this.goodsUseCase,
      required this.documentUseCases,
      required this.suppliersUseCase,
      required this.customersUseCase})
      : super(ReportDetailState.initial(state: InitialState()));

  void init(
    BuildContext context,
    ReportType type,
    DateTime? start,
    DateTime? end, {
    int? groupId,
    int? customerId,
    int? supplierId,
  }) async {
    emit(
      state.copyWith(
        state: LoadingState(),
        type: type,
        start: start,
        end: end,
      ),
    );
    var reportData = factory.create(
      type,
      start,
      end,
      groupId: groupId,
      customerId: customerId,
      supplierId: supplierId,
    );
    var columnInfos = reportData.getColumnInfos();
    var data = await reportData.getData();
    if (isClosed) return;
    // Hide the columns of Good properties the Store turned off.
    final visible = applyColumnVisibility(
      columnInfos,
      data,
      AppSettings.getGoodPropertiesSettings(),
      documentProperties: AppSettings.getDocumentPropertiesSettings(),
    );
    columnInfos = visible.columns;
    data = visible.rows;
    var columnReports = getColumnReports(columnInfos, data);
    emit(state.copyWith(columnReports: columnReports, rows: data));
    updateTableData(context);
  }

  List<ColumnReport> getColumnReports(
      List<ColumnInfo> columnInfos, List<MapEntry<int, List<String>>> data) {
    List<ColumnReport> columnReports = [];
    List<Set<String>> valueSets = getValueSets(data, columnInfos.length);

    for (int i = 0; i < columnInfos.length; i++) {
      ColumnInfo columnInfo = columnInfos[i];

      ColumnReport columnReport;
      if (columnInfo.isPickValues) {
        columnReport = PickableColumn(
            title: columnInfo.name,
            isVisible: true,
            showTotal: columnInfo.showTotal,
            isQuantity: columnInfo.isQuantity,
            values: Set.of(valueSets[i]),
            selectedValues: Set.of(valueSets[i]));
      } else {
        columnReport = SimpleColumn(
            title: columnInfo.name,
            isVisible: true,
            showTotal: columnInfo.showTotal,
            isQuantity: columnInfo.isQuantity);
      }
      columnReports.add(columnReport);
    }
    return columnReports;
  }

  List<Set<String>> getValueSets(
      List<MapEntry<int, List<String>>> data, int columnCount) {
    List<Set<String>> columnSets =
        List.generate(columnCount, (_) => <String>{});

    for (var row in data) {
      for (int col = 0; col < columnCount; col++) {
        columnSets[col].add(row.value[col]);
      }
    }
    return columnSets;
  }

  void updateTableData(
    BuildContext context,
  ) {
    if (isClosed) return;
    List<List<String>> data = [];
    List<String> header = [];
    for (var column in state.columnReports) {
      if (column.isVisible) {
        header.add(context.tr(column.title));
      }
    }
    data.add(header);
    List<MapEntry<int, List<String>>> rows = state.rows;
    List<List<String>> validRows = [];
    List<int?> ids = [];
    for (int i = 0; i < rows.length; i++) {
      var key = rows[i].key;
      var row = rows[i].value;
      var valid = true;
      for (int j = 0; j < state.columnReports.length; j++) {
        valid = isValid(state.columnReports[j], row[j]);
        if (!valid) {
          break;
        }
      }
      if (valid) {
        ids.add(key);
        validRows.add(row);
      }
    }
    emit(state.copyWith(ids: ids));
    if (validRows.length > 0) {
      List<String> totalRow = [];
      totalRow.add("Total");
      for (int i = 1; i < state.columnReports.length; i++) {
        if (state.columnReports[i].showTotal) {
          var sumAmount = 0.0;
          for (int j = 0; j < validRows.length; j++) {
            sumAmount += getDoubleFromFormattedText(validRows[j][i]);
          }
          totalRow.add(formatColumnTotal(sumAmount,
              isQuantity: state.columnReports[i].isQuantity));
        } else {
          totalRow.add("");
        }
      }
      validRows.add(totalRow);
    }
    for (var row in validRows) {
      List<String> rowData = [];
      for (int j = 0; j < state.columnReports.length; j++) {
        if (state.columnReports[j].isVisible) {
          rowData.add(row[j]);
        }
      }
      data.add(rowData);
    }
    emit(state.copyWith(state: LoadSuccessState(), data: data));
  }

  bool isValid(ColumnReport column, String value) {
    if (!column.isVisible) return true;
    if (column is PickableColumn) {
      return column.selectedValues.contains(value);
    }
    return true;
  }

  double getTotal(List<Payment> payments) {
    return payments
        .toList()
        .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
  }

  String getDateTimeText(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return DateFormatFactory.getDateFormat().format(dateTime);
  }

  double getDoubleFromFormattedText(String input) {
    return double.tryParse(input.replaceAll(",", "")) ?? 0;
  }

  void setColumns(List<ColumnReport> values, BuildContext context) {
    emit(state.copyWith(columnReports: values));
    updateTableData(context);
  }

  Future<Good> getGood(int id) {
    return goodsUseCase.get(id);
  }

  Future<Document> getDocument(int id) {
    return documentUseCases.get(id);
  }

  Future<Supplier> getSupplier(int id) {
    return suppliersUseCase.get(id);
  }

  Future<Customer> getCustomer(int id) {
    return customersUseCase.get(id);
  }

  String getSelectedStoreName() {
    return AppSettings.getSelectedStoreName();
  }
}
