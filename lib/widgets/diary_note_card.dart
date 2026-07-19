import 'package:brewstreet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.defaultCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.defaultCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.quicksand(
                    color: AppColors.brownMid,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
                onPressed: onToggle,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            body,
            style: GoogleFonts.quicksand(
              color: AppColors.brownMid,
              fontWeight: FontWeight.w500
            ),
          ),

          if (expanded) ...[
            const SizedBox(height: 10),
            const Center(child: Text("•••")),
          ],
        ],
      ),
    );
  }
}