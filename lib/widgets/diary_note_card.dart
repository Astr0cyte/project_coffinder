import 'package:brewstreet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dropdown_card.dart';

class DiaryNoteCard extends StatelessWidget {
  final String title;
  final String body;
  final bool expanded;
  final VoidCallback onToggle;

  const DiaryNoteCard({
    super.key,
    required this.title,
    required this.body,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownCard(
      expanded: expanded,
      onToggle: onToggle,
      header: Text(
        title,
        style: GoogleFonts.quicksand(
          color: AppColors.brownMid,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Text(
        body,
        style: GoogleFonts.quicksand(
          color: AppColors.brownMid,
          fontWeight: FontWeight.w500,
        ),
      ),
      expandedContent: const Center(child: Text("•••")),
    );
  }
}