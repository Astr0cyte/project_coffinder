import 'package:flutter/material.dart';
import '../states/review_state.dart';

/// Wrap of selectable pill-shaped chips representing [PlaceFeature]s.
class FeatureChipSelector extends StatelessWidget {
  const FeatureChipSelector({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  final Set<PlaceFeature> selected;
  final ValueChanged<PlaceFeature> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: PlaceFeature.values.map((feature) {
        final isSelected = selected.contains(feature);
        return GestureDetector(
          onTap: () => onToggle(feature),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF7E654C)
                  : const Color(0xFFF5EFD8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              feature.label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF3E2A20),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}