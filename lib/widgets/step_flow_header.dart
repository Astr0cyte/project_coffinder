import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Top header used by every step of the Add Cafe flow: a back arrow, a
/// segmented step-progress bar with "current/total" label, and a "Skip"
/// link — matches the mockup's `1/4 ... Skip →` bar.
class StepFlowHeader extends StatelessWidget {
  const StepFlowHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
    this.onSkip,
  });

  final int currentStep; // 1-based
  final int totalSteps;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  static const _textColor = Color(0xFF3E2A20);
  static const _activeColor = Color(0xFF3E2A20);
  static const _inactiveColor = Color(0xFFE3DACB);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
              child: const Icon(Icons.arrow_back, color: _textColor),
            ),
            Text(
              '$currentStep/$totalSteps',
              style: GoogleFonts.playfairDisplay(
                fontSize: 13,
                color: _textColor.withOpacity(0.5),
              ),
            ),
            GestureDetector(
              onTap: onSkip,
              child: Row(
                children: [
                  Text(
                    'Skip',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      color: _textColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward,
                      size: 16, color: _textColor.withOpacity(0.7)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index == totalSteps - 1 ? 0 : 6,
                ),
                height: 3,
                decoration: BoxDecoration(
                  color: isActive ? _activeColor : _inactiveColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}