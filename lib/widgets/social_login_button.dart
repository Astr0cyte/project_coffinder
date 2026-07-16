import 'package:flutter/material.dart';

/// Outlined pill button used for "Continue with Google/Facebook" etc.
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE3DACB)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF3E2A20),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders the Google "G" mark from a local image asset instead of a
/// hand-drawn vector. Add the official asset to your project (see
/// https://developers.google.com/identity/branding-guidelines) at
/// `assets/images/google_logo.png`, then register it in `pubspec.yaml`:
///
/// ```yaml
/// flutter:
///   assets:
///     - assets/images/google_logo.png
/// ```
class GoogleLogoIcon extends StatelessWidget {
  const GoogleLogoIcon({
    super.key,
    this.size = 20,
    this.assetPath = 'assets/google.png',
  });

  final double size;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) {
        // Falls back to a plain "G" if the asset hasn't been added yet,
        // so the app doesn't crash while you're wiring up the image.
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              'G',
              style: TextStyle(
                fontSize: size * 0.85,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4285F4),
              ),
            ),
          ),
        );
      },
    );
  }
}