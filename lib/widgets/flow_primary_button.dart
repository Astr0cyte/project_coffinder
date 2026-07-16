import 'package:flutter/material.dart';

/// Full-width rounded primary button used for "Continue" / "Post" at the
/// bottom of each step.
class FlowPrimaryButton extends StatelessWidget {
  const FlowPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  static const _buttonColor = Color(0xFF8A6A50);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonColor,
          disabledBackgroundColor: _buttonColor.withOpacity(0.5),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}