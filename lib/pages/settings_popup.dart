import 'package:brewstreet_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFAF9F4),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6EF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Settings",
              style: GoogleFonts.playfairDisplay(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF402F11),
              ),
            ),

            const SizedBox(height: 12),

            Divider(
              color: const Color(0xFFE6DFC9),
              thickness: 2,
            ),

            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                "Language",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: const Color(0xFF5C4636),
                ),
              ),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 18),
                  title: Text(
                    "English",
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9C8470),
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 18),
                  title: Text(
                    "Vietnamese",
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9C8470),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),

            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                "Theme",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: const Color(0xFF7E654C),
                ),
              ),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 18),
                  title: Text(
                    "Light",
                    style: GoogleFonts.inter(),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 18),
                  title: Text(
                    "Dark",
                    style: GoogleFonts.inter(),
                  ),
                  onTap: () {},
                ),
               ],
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Sign out",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: const Color(0xFF7E654C),
                ),
              ),
              onTap: () {
                // Naviagator only change UI
                // TODO:  --> Clear Token Login (Future Development)
                // Reason: User close && reopen the app --> REMAIN Logged
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}