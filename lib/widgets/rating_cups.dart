import 'package:flutter/material.dart';

/// Row of tappable cup icons used to pick an overall rating (1..[count]).
class RatingCups extends StatelessWidget {
  const RatingCups({
    super.key,
    required this.rating,
    required this.onChanged,
    this.count = 5,
    this.filledColor = const Color(0xFF7E654C),
    this.emptyColor = const Color(0xFFD9CFC2),
    this.size = 32,
  });

  final int rating;
  final ValueChanged<int> onChanged;
  final int count;
  final Color filledColor;
  final Color emptyColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (index) {
        final cupValue = index + 1;
        final isFilled = cupValue <= rating;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => onChanged(cupValue),
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.coffee,
              size: size,
              color: isFilled ? filledColor : emptyColor,
            ),
          ),
        );
      }),
    );
  }
}