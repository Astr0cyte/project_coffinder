import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:project_coffinder/pages/diary_page.dart';
=======
import 'app_colors.dart';
import 'home_screen.dart';
>>>>>>> 3d25dffdee444092141b20c5b9bed1f9f2ed640b

void main() => runApp(const CafeApp());

class CafeApp extends StatelessWidget {
  const CafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
      ),
      home: SignInPage(),
=======
      title: 'BrewStreet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: AppColors.cream),
      home: const HomeScreen(),
>>>>>>> 3d25dffdee444092141b20c5b9bed1f9f2ed640b
    );
  }
}


