import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import 'Indicators.dart';

class GenderChart extends StatefulWidget {
  const GenderChart({super.key});

  @override
  State<StatefulWidget> createState() => _GenderChartState();
}

class _GenderChartState extends State {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

      SizedBox(
      width:160,
      height:160,
      child: AspectRatio(
        aspectRatio: 1.3,
        child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: showingSections(),
            ),
          ),
        ),
      ),
    ),
        const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Indicator( color: AppColors.primary, text: 'Femme', isSquare: true),
            SizedBox(
              height: 4,
            ),
            Indicator( color: AppColors.secondary, text: 'Homme', isSquare: true),
            SizedBox(
              height: 4,
            ),
            Indicator( color: Colors.deepPurple, text: 'Autre', isSquare: true),
            SizedBox(
              height: 4,
            ),
          ],
        ),
      ],
    ) ;
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final fontSize = 16.0;
      final radius = 100.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.primary,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.secondary,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.deepPurple,
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          throw Exception('Error');
      }
    });
  }
}