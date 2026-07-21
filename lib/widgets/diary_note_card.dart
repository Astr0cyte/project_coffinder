import 'package:flutter/material.dart';

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

  bool get _isLongNote =>
    body.length > 120 || body.split('\n').length > 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF7F2E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffDCCFB8),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_isLongNote)
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
            maxLines: _isLongNote ? (expanded ? null : 3) : null,
            overflow: _isLongNote
            ? TextOverflow.fade
            : TextOverflow.visible,
          ),

          if (_isLongNote && expanded) ...[
            const SizedBox(height: 10),
            const Center(child: Text("•••")),
          ],
        ],
      ),
    );
  }
}