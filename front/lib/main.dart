import 'package:flutter/material.dart';
import 'package:front/providers/auth.dart';
import 'package:front/providers/user.dart';
import 'package:front/views/homepage/homepage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constants/colors.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await Hive.openBox('customer');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final AuthProvider authProvider = AuthProvider();
  final UserProvider userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: userProvider),
      ],
      child: MaterialApp(
        title: 'Sésame POC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          fontFamily: 'Poppins',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(),
            bodySmall: TextStyle(),
            bodyMedium: TextStyle(),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}