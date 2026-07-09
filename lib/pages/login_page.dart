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
                alignment: Alignment(0, 0.57),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(133, 115, 98, 1.0),
                    ),
                    fixedSize: const Size(327, 48),
                    elevation: 1.0,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
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
                alignment: Alignment(0, 0.70),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(230, 230, 230, 1),
                    ),
                    fixedSize: const Size(327, 48),
                    elevation: 1.0,
                    shadowColor: const Color.fromARGB(255, 144, 144, 144),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                    foregroundColor: Color.fromRGBO(184, 184, 184, 1),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Sign in or create account",
                    style: GoogleFonts.questrial(
                      fontSize: 16,
                      color: Color.fromRGBO(175, 175, 175, 1),
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
