import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(250, 249, 244, 1.0),
          ),

          child: Stack(
            children: [
              // Welcome to + BrewStreet! (2 separate Text widgets)
              Align(
                alignment: Alignment(0, -0.7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // "Welcome to"
                    Text(
                      "Welcome to",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(126, 101, 76, 1.0),
                      ),
                    ),

                    // "BrewStreet!"
                    Text(
                      "BrewStreet",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(126, 101, 76, 1.0),
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment(0, 0.1),
                child: Text(
                  "Discover hidden gems in Saigon!",
                  style: GoogleFonts.questrial(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(126, 101, 76, 1.0),
                  ),
                ),
              ),

              // Logo
              Align(
                alignment: Alignment(0, -0.25),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [

                    // Circle
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(238, 233, 220, 1.0),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.fromRGBO(203, 187, 144, 1.0),
                          width: 1.0,
                        ),
                      ),
                    ),

                    // Mascot
                    Positioned(
                      top: 0,
                      left: -10,
                      child: Image.asset(
                        'assets/logo.png',
                        width: 175,
                        height: 175,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              // "Continue as guest" button
              Align(
                alignment: Alignment(0, 0.6),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    fixedSize: const Size(270, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                    ),
                    backgroundColor: Color.fromRGBO(126, 101, 76, 1.0),
                    foregroundColor: Color.fromRGBO(223, 217, 185, 1.0),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Continue as guest",
                    style: GoogleFonts.questrial(
                      fontSize: 18,
                      color: Color.fromRGBO(223, 217, 185, 1.0),
                    ),
                  ),
                ),
              ),

              // "Sign in or create account" button
              Align(
                alignment: Alignment(0, 0.73),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(224, 33),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(15),
                    ),
                    backgroundColor: Color.fromRGBO(250, 249, 244, 0),
                    foregroundColor: Color.fromRGBO(223, 217, 185, 1.0),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Sign in or create account",
                    style: GoogleFonts.questrial(
                      fontSize: 14,
                      color: Color.fromRGBO(126, 101, 76, 1.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
