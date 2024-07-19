import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:front/models/bathrooms.dart';

Future<List<Bathrooms>> getAllBathrooms() async {

  final token = await initHiveBox();

  final response = await http.get(Uri.parse("http://localhost:8080/api/toilets/"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      });

  final responseJson = jsonDecode(response.body);

  final arrayBathrooms = [];

  for(int i = 0; i < responseJson.length; i++) {
    arrayBathrooms.add({
      'id': responseJson[i]['id'],
      'label': responseJson[i]['label'],
      'state': responseJson[i]['state'],
      'locationX': responseJson[i]['coordinates']['x'],
      'locationY': responseJson[i]['coordinates']['y'],
    });
  }

  return List.from(arrayBathrooms).map((e) => Bathrooms.fromMap(e)).toList();
}

Future<Bathrooms> getBathroomById(bathroomId) async {
  final token = await initHiveBox();

  final response = await http.get(Uri.parse("http://localhost:8080/api/toilets/$bathroomId"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      });

  final responseJson = jsonDecode(response.body);

  Map<String, dynamic> arrayBathrooms = ({
    'id': responseJson['id'],
    'label': responseJson['label'],
    'state': responseJson['state'],
    'locationX': responseJson['coordinates']['x'],
    'locationY': responseJson['coordinates']['y'],
  });

  return Bathrooms.fromMap(arrayBathrooms);
}

Future<dynamic> initHiveBox() async {
  final box = await Hive.openBox('customer');
  final token = box.get('token');
  return token;
}