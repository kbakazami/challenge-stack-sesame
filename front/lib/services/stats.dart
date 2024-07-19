import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/stats.dart';
import 'hive.dart';
import 'package:intl/intl.dart';

Future<StatsData> getStats () async {
  final token = await initHiveBox();
  final averageScore = await getScore(token);
  final nbrPassage = await getNbrPassage(token);
  final averageTime = await getAverageTime(token);

  Map<String, dynamic> stats = ({
    "averageScore":averageScore,
    "nbrPassage":nbrPassage,
    "averageTime": averageTime,
  });

  return StatsData.fromJson(stats);
}

Future<dynamic> getScore (token) async {
  final response = await http.get(Uri.parse("http://localhost:8080/api/feedback/avg_score"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      });

  final responseJson = jsonDecode(response.body);
  late double avgScore = 0;

  for(int i = 0; i < responseJson.length; i++)
  {
    avgScore += (responseJson[i][1] + responseJson[i][2] + responseJson[i][3] + responseJson[i][4] ) / 4;
  }

  return (avgScore / responseJson.length);
}

Future<dynamic> getNbrPassage (token) async {
  final response = await http.get(Uri.parse("http://localhost:8080/api/stats/get_nb_passage"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      });

  final responseJson = jsonDecode(response.body);
  late int nbrPassage;

  final DateTime now = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);


  for(int i = 0; i < responseJson.length; i++)
  {
    if(responseJson[i][0] == formattedDate) {
      nbrPassage = responseJson[i][1];
    }
  }

  return nbrPassage;
}

Future<dynamic> getAverageTime (token) async {

  final response = await http.get(Uri.parse("http://localhost:8080/api/stats/get_nb_passage"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      });

  final responseJson = jsonDecode(response.body);
  late int averageTime;

  averageTime = 5;

  return averageTime;
}