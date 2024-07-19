import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class Chart extends StatefulWidget {
  Chart({super.key});
  final Color leftBarColor = AppColors.primary;
  final Color rightBarColor = AppColors.secondary;
  final Color avgColor = Color(0xFF000000);
  @override
  State<StatefulWidget> createState() => ChartState();
}

class ChartState extends State<Chart> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup0 = makeGroupData(0, 255);
    final barGroup1 = makeGroupData(1, 1000);
    final barGroup2 = makeGroupData(2, 756);
    final barGroup3 = makeGroupData(3, 555);
    final barGroup4 = makeGroupData(4, 479);
    final barGroup5 = makeGroupData(5, 100);
    final barGroup6 = makeGroupData(6, 1587);
    final barGroup7 = makeGroupData(7, 252);
    final barGroup8 = makeGroupData(8, 178);
    final barGroup9 = makeGroupData(9, 247);
    final barGroup10 = makeGroupData(10, 987);
    final barGroup11 = makeGroupData(11, 354);
    final barGroup12 = makeGroupData(12, 123);
    final barGroup13 = makeGroupData(13, 234);
    final barGroup14 = makeGroupData(14, 345);
    final barGroup15 = makeGroupData(15, 456);
    final barGroup16 = makeGroupData(16, 567);
    final barGroup17 = makeGroupData(17, 789);
    final barGroup18 = makeGroupData(18, 901);
    final barGroup19 = makeGroupData(19, 102);
    final barGroup20 = makeGroupData(20, 287);
    final barGroup21 = makeGroupData(21, 876);
    final barGroup22 = makeGroupData(22, 180);
    final barGroup23 = makeGroupData(23, 106);

    final items = [
      barGroup0,
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
      barGroup8,
      barGroup9,
      barGroup10,
      barGroup11,
      barGroup12,
      barGroup13,
      barGroup14,
      barGroup15,
      barGroup16,
      barGroup17,
      barGroup18,
      barGroup19,
      barGroup20,
      barGroup21,
      barGroup22,
      barGroup23,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      height: 200,
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 2000,
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
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false,),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '250';
    } else if (value == 50) {
      text = '500';
    } else if (value == 100) {
      text = '1000';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['0', '1', '2', '3', '4', '5', '6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        )
      ],
    );
  }
}