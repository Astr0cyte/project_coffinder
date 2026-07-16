import 'package:flutter/material.dart';

/// Multiline text field used for the "Your experience" section.
class ExperienceInput extends StatelessWidget {
  const ExperienceInput({
    super.key,
    required this.controller,
    this.hintText = 'Write your ideas here',
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFD8),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        maxLines: 6,
        style: const TextStyle(color: Color(0xFF3E2A20), fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: const Color(0xFF3E2A20).withOpacity(0.45)),
        ),
      ),
    );
  }
}