import 'package:flutter/material.dart';

/// A smooth, warm brown-to-cream gradient sitting behind the top of a
/// screen. Uses a single radial + linear gradient blend (no blur blobs,
/// which tend to render as blotchy patches) so the transition stays even.
class TopGradientBackdrop extends StatelessWidget {
  const TopGradientBackdrop({
    super.key,
    this.height = 220,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFA98F6B),
              Color(0xFFCBB595),
              Color(0xFFE8DCC4),
              Color(0xFFFAF6EE),
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
}