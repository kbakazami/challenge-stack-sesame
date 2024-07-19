import 'package:hive/hive.dart';

Future<dynamic> initHiveBox() async {
  final box = await Hive.openBox('customer');
  final token = box.get('token');
  return token;
}