import 'package:flutter/material.dart';
import 'states/add_cafe_state.dart';
import 'pages/add_cafe/step1_picture_page.dart';

/// Alternate entry point that boots straight into the Add Cafe flow,
/// skipping Login/SignIn/Register. Useful for testing this flow in
/// isolation on a feature branch.
///
/// Run with:
///   flutter run -t lib/main_add_cafe.dart
void main() {
  runApp(const AddCafeDevApp());
}

class AddCafeDevApp extends StatelessWidget {
  const AddCafeDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewStreet — Add Cafe (dev)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF6EE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8A6A50),
        ),
      ),
      home: Step1PicturePage(state: AddCafeState()),
    );
  }
}