import 'package:brewstreet_app/pages/app_colors.dart';
import 'package:brewstreet_app/pages/login_page.dart';
import 'package:flutter/material.dart';


void main() => runApp(const CafeApp());

class CafeApp extends StatelessWidget {
  const CafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewStreet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: AppColors.cream),
      home: const LoginPage(),
    );
  }
}