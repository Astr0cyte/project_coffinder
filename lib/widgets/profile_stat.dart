import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF402F11),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7E654C),
          ),
        ),
      ],
    );
  }
}