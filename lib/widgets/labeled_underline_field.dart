import 'package:flutter/material.dart';

/// A label + underlined text field, matching the "CAFE NAME *" style in
/// the mockup (as opposed to the filled pill style used on auth screens).
class LabeledUnderlineField extends StatelessWidget {
  const LabeledUnderlineField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.required = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final bool required;
  final TextInputType? keyboardType;

  static const _textColor = Color(0xFF3E2A20);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _textColor.withOpacity(0.7),
                letterSpacing: 0.5,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 3),
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 16,
            color: _textColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: _textColor.withOpacity(0.35),
              fontWeight: FontWeight.w500,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.only(bottom: 10),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _textColor.withOpacity(0.3)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _textColor.withOpacity(0.3)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: _textColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}