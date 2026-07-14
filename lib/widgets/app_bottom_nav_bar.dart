import 'package:flutter/material.dart';

/// The 5-icon bottom navigation bar shown across the app (home, add/switch,
/// history, saved, settings).
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    this.currentIndex = 1,
    this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int>? onTap;

  static const _activeColor = Color(0xFF3E2A20);
  static const _inactiveColor = Color(0xFFBBAF9C);

  static const _icons = [
    Icons.home_outlined,
    Icons.compare_arrows,
    Icons.access_time,
    Icons.bookmark_border,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDE6D8))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_icons.length, (index) {
          final isActive = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap?.call(index),
            child: Icon(
              _icons[index],
              color: isActive ? _activeColor : _inactiveColor,
              size: 32,
            ),
          );
        }),
      ),
    );
  }
}