import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../states/review_state.dart';
import '../widgets/place_header.dart';
import '../widgets/rating_cups.dart';
import '../widgets/feature_chip_selector.dart';
import '../widgets/experience_input.dart';

class PostPage extends StatefulWidget {
  const PostPage({
    super.key,
    required this.placeName,
    required this.placeAddress,
    this.onSubmit,
  });

  final String placeName;
  final String placeAddress;

  /// Called with the final [ReviewState] when the user taps "Post Review".
  final ValueChanged<ReviewState>? onSubmit;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late final ReviewState _state;
  late final TextEditingController _experienceController;

  @override
  void initState() {
    super.initState();
    _state = ReviewState();
    _experienceController = TextEditingController();
    _state.addListener(_onStateChanged);
    _experienceController.addListener(() {
      _state.setExperience(_experienceController.text);
    });
  }

  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _state.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _handlePostReview() {
    widget.onSubmit?.call(_state);
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFAF9F4);
    const textColor = Color(0xFF402F11);
    const yellowButton = Color(0xFFF5EFD8);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                  child: PlaceHeader(
                    name: widget.placeName.toUpperCase(),
                    address: widget.placeAddress,
                    nameStyle: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.9),
                  child: Text(
                    'Share your visit',
                    style: GoogleFonts.playfairDisplay( // Updated to playfairDisplay
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const Divider(color: Color(0xFFE3DACB)),
                const SizedBox(height: 20),

                // --- NEW PADDED SECTION ---
                // Wrapping the rest of the content in a Padding and Column
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust this for more/less indent
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall rating',
                        style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      RatingCups(rating: _state.rating, onChanged: _state.setRating),
                      const SizedBox(height: 28),

                      Text(
                        'What features did you like?',
                        style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FeatureChipSelector(
                        selected: _state.selectedFeatures,
                        onToggle: _state.toggleFeature,
                      ),
                      const SizedBox(height: 28),

                      Text(
                        'Your experience',
                        style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ExperienceInput(controller: _experienceController),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _state.canSubmit ? _handlePostReview : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7E654C),
                            disabledBackgroundColor: const Color(0xFF8A6A50).withAlpha(128),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            'Post Review',
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFFDED4BA),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                // --- END PADDED SECTION ---

              ],
            ),
          ),
        ),
      ),
    );
  }
}