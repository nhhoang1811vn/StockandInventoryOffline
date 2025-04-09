import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/common/helpers/injection.container.dart';
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/expense_report_chart/expense_report_chart_cubit.dart';
import 'package:intl/intl.dart';

class ExpenseReportChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExpenseReportChartWidgetState();
  }
}

class ExpenseReportChartWidgetState extends State<ExpenseReportChartWidget> {
  late ExpenseReportChartState mState;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => ExpenseReportChartCubit(useCase: getIt<ExpenseUseCases>())..initState(), child: BlocConsumer<ExpenseReportChartCubit, ExpenseReportChartState>(builder: (BuildContext context, ExpenseReportChartState state) {
      mState = state;
      return Card(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Expense Report in last 6 months", style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 16,),
                  SizedBox(height: 250, child: LineChart(getLineChartData(state), duration: const Duration(milliseconds: 250)),)

                ],
              )));
    }, listener: (BuildContext context, ExpenseReportChartState state) {  },));

  }
  LineChartData getLineChartData(ExpenseReportChartState state) {
    return LineChartData(
      lineTouchData: lineTouchData1,
      gridData: gridData,
      titlesData: titlesData1,
      borderData: borderData,
      lineBarsData: getLineBarsData(state),  // Use the cubit state data here
      minX: 0,
      maxX: 5,//6 months
      maxY: 4,
      minY: 0,
    );
  }
  List<LineChartBarData> getLineBarsData(ExpenseReportChartState state){
    List<FlSpot> spots1 = state.data.map((item) {
      return FlSpot(item.key, item.value);
    }).toList();
    return [
      LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: spots1,  // Use dynamic spots from state
      ),
    ];
  }

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) =>
          Colors.blueGrey.withValues(alpha: 0.8),
    ),
  );

  FlGridData get gridData => const FlGridData(show: true);

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

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
