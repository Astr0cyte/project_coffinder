import 'package:flutter/material.dart';

/// Back button + place name/address header shown at the top of the page.
class PlaceHeader extends StatelessWidget {
  const PlaceHeader({
    super.key,
    required this.name,
    required this.address,
    this.onBack,
    this.nameStyle,
  });

  final String name;
  final String address;
  final VoidCallback? onBack;

  /// Optional override for the place name's text style (e.g. a custom
  /// Google Font). Falls back to the default bold style when not set.
  final TextStyle? nameStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Arrow button: its own alignment, pulled flush to the left edge
        Transform.translate(
          offset: const Offset(-22, -5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Material(
              color: const Color(0xFFFFFFFF).withAlpha(25), // Base background color (~10% opacity)
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
                // Explicitly defining the interaction colors for clear visibility
                hoverColor: const Color(0xFF402F11).withAlpha(25),     // Subtle brown tint on hover
                highlightColor: const Color(0xFF402F11).withAlpha(50), // Darker tint when pressed down
                splashColor: const Color(0xFF402F11).withAlpha(75),    // Distinct ripple effect
                child: const Padding(
                  padding: EdgeInsets.all(10), // Keep the inner spacing around the icon
                  child: Icon(Icons.arrow_back, color: Color(0xFF402F11)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Place-info block: indented slightly, a separate visual group from the arrow
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Color(0xFF3E2A20), size: 15),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: nameStyle ??
                          const TextStyle(
                            color: Color(0xFF3E2A20),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address,
                      style: TextStyle(
                        color: const Color(0xFF3E2A20).withAlpha(153), // ~60% opacity
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}