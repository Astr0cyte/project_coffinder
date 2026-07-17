import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'pages/login_page.dart';

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

