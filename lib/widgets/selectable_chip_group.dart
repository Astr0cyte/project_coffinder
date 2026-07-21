import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A generic wrap of selectable pill-shaped chips. Unlike
/// `FeatureChipSelector` (which is tied to the `PlaceFeature` enum for the
/// review screen), this takes plain strings so it can be reused for any
/// label set — e.g. "Vibe" or "Feature" in the Add Cafe flow.
class SelectableChipGroup extends StatelessWidget {
  const SelectableChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onToggle,
    this.trailing,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  /// Optional trailing chip, e.g. a "More …" chip that isn't part of
  /// [options] and doesn't participate in selection state.
  final Widget? trailing;

  // Khai báo các màu đồng bộ với format cũ
  static const _textColor = Color(0xFF7E654C);
  static const _unselectedBgColor = Color(0xFFF2EFDE);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...options.map((option) {
          final isSelected = selected.contains(option);
          return GestureDetector(
            onTap: () => onToggle(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? _textColor
                    : _unselectedBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                option,
                style: GoogleFonts.quicksand(
                  color: isSelected ? Colors.white : _textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),
        if (trailing != null) trailing!,
      ],
    );
  }
}