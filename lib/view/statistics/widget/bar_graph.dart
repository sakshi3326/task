import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/view/statistics/widget/bar_data.dart';

class BarGraphView extends StatelessWidget {
  final List weeklySummary;
  const BarGraphView({required this.weeklySummary, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunTask: weeklySummary[0],
      monTask: weeklySummary[1],
      tueTask: weeklySummary[2],
      wedTask: weeklySummary[3],
      thurTask: weeklySummary[4],
      friTask: weeklySummary[5],
      satTask: weeklySummary[6],
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, getTitlesWidget: getBottomTitles))),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: CommonColors.bottomIconColor,
                    width: 30,
                    borderRadius: BorderRadius.circular(08),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 100,
                      color: CommonColors.bottomIconColor.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: CommonColors.blackColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text("Sun", style: style);
        break;
      case 1:
        text = const Text("Mon", style: style);
        break;
      case 2:
        text = const Text("Tue", style: style);
        break;
      case 3:
        text = const Text("Wed", style: style);
        break;
      case 4:
        text = const Text("Thur", style: style);
        break;
      case 5:
        text = const Text("Fri", style: style);
        break;
      case 6:
        text = const Text("Sat", style: style);
        break;
      default:
        text = const Text("", style: style);
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
