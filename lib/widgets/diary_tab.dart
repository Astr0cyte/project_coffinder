import 'package:brewstreet_app/theme/app_colors.dart';
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
              ? AppColors.chipDark
              : AppColors.chipLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected 
              ? const Color(0xFF6E573E)
              : const Color(0xffD8CCBA),
              width: 1
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.quicksand(
            color: selected ? AppColors.cream : const Color(0xff7A6755),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}