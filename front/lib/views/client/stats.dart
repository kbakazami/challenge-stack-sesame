import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:front/constants/colors.dart';
import 'package:front/models/stats.dart';

import '../../services/stats.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../widgets/chart.dart';
import '../../widgets/chartCircle.dart';
import '../../widgets/chartCircleGender.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  late Future<StatsData> futureStats;


  @override
  void initState() {
    super.initState();
    futureStats = getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: SingleChildScrollView(
            child:  Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/dashboard.svg"),
                    const SizedBox(width: 10),
                    const Text("Dashboard", style: TextStyle(fontSize: 32),),
                  ],
                ),
                const SizedBox(height: 40),
                FutureBuilder<StatsData>(
                    future: futureStats,
                    builder: (context, snapshot) {
                      if(snapshot.hasError) {
                        return const Text('Une erreur est survenue, veuillez réessayer.');
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final stats = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cardStats('Moyenne des notes', 'score.svg', stats.averageScore.toString(), "Les utilisateurs notent la propreté des toilettes, la qualité du service"),
                          cardStats('Nombre de passage', 'peoples.svg', stats.nbrPassage.toString(), "Le bras mécanique commence à se détériorer au bout de 30000 passages"),
                          cardStats('Durée moyenne d’un passage', 'clock.svg', "${stats.averageTime.toString()}min", "Au delà de 30 minutes le système envoie une notification de prévention afin d’ouvrir la porte"),
                          cardStats('Heure de maintenance', 'Bucket.svg', "15h", "L’heure d’affluence est à 15h aujourd’hui il faut prévoir une maintenance pour laver les sanitaires")
                        ],
                      );
                    }
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text('Nombre de passage / Heure '),
                          SvgPicture.asset("assets/icons/clock.svg"),
                        ],
                        ),
                        SizedBox(height: 15),
                        Chart(),
                      ],
                    ),
                    SizedBox(width: 80),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text('Tranche d\'âge'),
                          SvgPicture.asset("assets/icons/peoples.svg"),
                        ],
                        ),
                        SizedBox(height: 40),
                        AverageYearChart(),
                      ],
                    ),
                    SizedBox(width: 80),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SvgPicture.asset("assets/icons/boy.svg"),
                            Text('Proportion'),
                            SvgPicture.asset("assets/icons/girl.svg"),
                          ],
                        ),
                        SizedBox(height: 40),
                        GenderChart(),
                      ]
                    ),
                  ],
                )

              ],
            ),
          )
        )
    );
  }

  cardStats(String title, String iconName, dynamic statValue, String description) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: AppColors.primaryOpacity20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 14),),
              SvgPicture.asset("assets/icons/$iconName")
            ],
          ),
          Text(statValue, style: const TextStyle(fontSize: 48),),
          Text(description, style: const TextStyle(fontSize: 10, color: AppColors.gray),)
        ],
      ),
    );
  }


}

