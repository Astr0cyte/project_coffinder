import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiaryTab extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const DiaryTab({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xff4B3217)
              : const Color(0xffECE4D5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xffD8CCBA),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xff7A6755),
            fontSize: 12,
            fontWeight: GoogleFonts.quicksand().fontWeight,
          ),
        ),
      ),
    );
  }
}