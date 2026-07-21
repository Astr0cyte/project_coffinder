import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import 'dropdown_card.dart';

class DiaryNoteCard extends StatelessWidget {
  final String title;
  final String body;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;


  const DiaryNoteCard({
    super.key,
    required this.title,
    required this.body,
    required this.expanded,
    required this.onToggle,
    this.onEdit,
  });

  bool get _isLongNote =>
    body.length > 120 || body.split('\n').length > 4;

  @override
  Widget build(BuildContext context) {
    final header = Text(
      title,
      style: GoogleFonts.quicksand(
        color: AppColors.brownMid,
        fontWeight: FontWeight.w600,
      ),
    );

    final bodyText = Text(
      body,
      maxLines: _isLongNote ? (expanded ? null : 3) : null,
      overflow: _isLongNote ? TextOverflow.fade : TextOverflow.visible,
      style: GoogleFonts.quicksand(
        color: AppColors.brownMid,
        fontWeight: FontWeight.w500,
      ),
    );

    if (!_isLongNote) {
      return Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F7EE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFDDE1D0),
          ),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 2),
              color: Color.fromRGBO(204, 203, 199, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: header,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: bodyText,
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return DropdownCard(
      expanded: expanded,
      onToggle: onToggle,
      header: header,
      body: bodyText,
      expandedContent: _isLongNote && expanded
          ? const Center(child: Text(''))
          : null,
    );
  }
}