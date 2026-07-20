import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shown inside DiaryPage when the "Saved Shops" tab is selected.
class SavedShops extends StatelessWidget {
  const SavedShops({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your saved coffee shops",
          style: TextStyle(
            color: Colors.grey,
            fontFamily: GoogleFonts.quicksand().fontFamily,
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "No saved shops yet. Tap the heart on a shop to save it here.",
            style: TextStyle(
              color: Colors.grey,
              fontFamily: GoogleFonts.quicksand().fontFamily,
            ),
          ),
        ),
      ],
    );
  }
}