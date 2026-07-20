// import 'package:flutter/material.dart';
// import 'app_colors.dart';
// import 'pages/login_page.dart';
//
// void main() => runApp(const CafeApp());
//
// class CafeApp extends StatelessWidget {
//   const CafeApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'BrewStreet',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: AppColors.cream),
//       home: const LoginPage(),
//     );
//   }
// }
//


import 'package:brewstreet_app/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'pages/main_screen.dart'; // Đảm bảo đường dẫn import này trỏ đúng tới file main_screen.dart của bạn

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee App',
      theme: ThemeData(
        primarySwatch: Colors.brown,

        scaffoldBackgroundColor: const Color(0xFFFAF9F4),
      ),
      // Đặt MainScreen làm màn hình đầu tiên khởi chạy
      home: MainScreen(),
    );
  }
}
