import 'package:flutter/material.dart';
import 'package:front/views/homepage/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sésame POC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(),
          bodySmall: TextStyle(),
          bodyMedium: TextStyle(),
        ),
      ),
      home: const HomePage(),
    );
  }
}