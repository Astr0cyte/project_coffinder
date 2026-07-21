import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../services/review_service.dart';
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
    required this.cafeId,
  });

  final String placeName;
  final String placeAddress;
  final String cafeId;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late final ReviewState _state;
  late final TextEditingController _experienceController;
  bool _isPosting = false;

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

  Future<void> _handlePostReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to post a review.')),
      );
      return;
    }

    setState(() => _isPosting = true);
    try {
      await ReviewService.instance.createReview(
        uid: user.uid,
        cafeId: widget.cafeId,
        displayName: user.displayName?.trim().isNotEmpty == true
            ? user.displayName!
            : 'Anonymous',
        comment: _state.experience,
        rating: _state.rating,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post review: $e')),
      );
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.cream;
    const textColor = Color(0xFF402F11);
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
                    style: GoogleFonts.playfairDisplay(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          onPressed: (_state.canSubmit && !_isPosting)
                              ? _handlePostReview
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7E654C),
                            disabledBackgroundColor:
                                const Color(0xFF8A6A50).withAlpha(128),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: _isPosting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
