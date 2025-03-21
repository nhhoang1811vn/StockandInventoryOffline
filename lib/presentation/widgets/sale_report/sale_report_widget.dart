import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/common/helpers/injection.container.dart';
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/sale_report/sale_report_cubit.dart';
import 'package:intl/intl.dart';

import '../../../domain/usecases/documents/document_usecases.dart';

class SaleReportWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SaleReportWidgetState();
  }
}

class SaleReportWidgetState extends State<SaleReportWidget> {
  late SaleReportState mState;
  final double width = 7;
  final Color leftBarColor = Colors.red;
  final Color rightBarColor = Colors.green;
  //late List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups = [];
  BarChartGroupData makeGroupData(int x, double y1, double y2) {

    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: rightBarColor,
          width: width,
        ),
      ],
    );
  }
  @override
  void initState() {
    super.initState();
    // final barGroup1 = makeGroupData(0, 5, 12);
    // final barGroup2 = makeGroupData(1, 16, 12);
    // final barGroup3 = makeGroupData(2, 18, 5);
    // final barGroup4 = makeGroupData(3, 20, 16);
    // final barGroup5 = makeGroupData(4, 17, 6);
    // final barGroup6 = makeGroupData(5, 19, 1.5);
    // final barGroup7 = makeGroupData(6, 10, 1.5);
    //
    // final items = [
    //   barGroup1,
    //   barGroup2,
    //   barGroup3,
    //   barGroup4,
    //   barGroup5,
    //   barGroup6,
    //   barGroup7,
    // ];
    //
    // rawBarGroups = items;
    //
    // showingBarGroups = rawBarGroups;
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => SaleReportCubit(useCase: getIt<PaymentUseCases>())..initState(), child: BlocConsumer<SaleReportCubit, SaleReportState>(builder: (BuildContext context, SaleReportState state) {
      mState = state;
      return Card(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Sale Reports in last 6 months", style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 16,),
                  SizedBox(height: 250, child: _barChart(state))
                ],
              )));
    }, listener: (BuildContext context, SaleReportState state) {  },));
  }
  Widget _barChart(SaleReportState state){
    showingBarGroups.clear();
    for (int i = 0 ;i<state.data1.length;i++){
      double y1 = state.data1[i].value;
      double y2 = state.data2[i].value;
      showingBarGroups.add(makeGroupData(i, y1, y2));
    }
    return BarChart(BarChartData(
      maxY: 4,
      barTouchData: BarTouchData(

      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitleWidgets,
            reservedSize: 42,
          ),
        ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
            )),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingBarGroups,
      gridData: const FlGridData(show: false),
    ));
  }


  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (mState.startDate != null){
      DateTime dateTime = DateTimeUtils.addMonths(mState.startDate!, value.toInt());
      Widget text = Text(DateFormat('MMM').format(dateTime), style: Theme.of(context).textTheme.bodySmall);
      return SideTitleWidget(
        meta: meta,
        space: 10,
        child: text
      );
    }else{
      return SizedBox.shrink();
    }

  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    // Access maxTotalAmount from state
    double maxTotalAmount = mState.maxTotalAmount;

    // Determine the text based on the value and maxTotalAmount
    if (value >= 0 && value <= 4) {
      // Scale the value based on maxTotalAmount
      double adjustedValue = value * (maxTotalAmount / 4);

      // Format the adjusted value using the formatNumber function
      text = Utils.formatNumber(adjustedValue); // Convert the number to 'K', 'M', or 'B' format
    } else {
      return Container(); // If the value is outside the expected range, return an empty container
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom:
              BorderSide(color: Colors.blue.withValues(alpha: 0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );
}
