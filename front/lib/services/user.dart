import 'dart:convert';
import 'dart:io';

import 'hive.dart';
import 'package:http/http.dart' as http;

Future<dynamic> deleteUserById(userId) async {
  final token = await initHiveBox();

  final response = await http.delete(Uri.parse("http://localhost:8080/api/users/$userId"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      });

  return response.statusCode;
}

Future<dynamic> createUser(token, role) async {
  final response = await http.post(Uri.parse("http://localhost:8080/api/auth/verify"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: jsonEncode(
          {"role" : role}
      )
  );

  return response;
}