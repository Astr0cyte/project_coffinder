import 'package:flutter/material.dart';

class DropdownCard extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget? expandedContent;
  final bool expanded;
  final VoidCallback onToggle;

  const DropdownCard({
    super.key,
    required this.header,
    required this.body,
    required this.expanded,
    required this.onToggle,
    this.expandedContent,
  });

  @override
  Widget build(BuildContext context) {
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
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.topCenter,
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(child: header),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Image.asset(
                        'assets/arrow_down.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: body,
            ),
            if (expandedContent != null && expanded) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: expandedContent!,
              ),
              const SizedBox(height: 16),
            ] else
              const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
