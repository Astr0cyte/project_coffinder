import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomFloatingNavBar extends StatelessWidget {
  final bool isVisible;
  final int currentIndex;
  final Function(int) onTap;

  const CustomFloatingNavBar({
    super.key,
    this.isVisible = true,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        offset: isVisible ? Offset.zero : const Offset(0, 1.6),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: isVisible ? 1 : 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              // Reduced from 45 to 24 to match the shorter blurred area
              borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.5,
                      colors: [
                        AppColors.brownDark.withOpacity(0.35),
                        AppColors.cream.withOpacity(0.05),
                      ],
                    ),
                  ),
                  // Reduced top padding from 32 to 12 to make the blur background smaller
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: SafeArea(
                    top: false,
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.brownDark,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: AppColors.brownDark.withOpacity(0.6),
                            blurRadius: 35,
                            spreadRadius: 12,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavIcon(Icons.home, 0),
                          _buildNavIcon(Icons.bookmark_border, 1),
                          _buildNavIcon(Icons.add, 2),
                          _buildNavIcon(Icons.person_outline, 3),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final bool active = currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? AppColors.tan : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 20,
          color: active ? AppColors.brownDark : AppColors.tan.withOpacity(0.6),
        ),
      ),
    );
  }
}