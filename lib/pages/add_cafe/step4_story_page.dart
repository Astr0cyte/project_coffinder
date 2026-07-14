import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../states/add_cafe_state.dart';
import '../../widgets/step_flow_header.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/flow_primary_button.dart';

class Step4StoryPage extends StatefulWidget {
  const Step4StoryPage({
    super.key,
    required this.state,
    this.onPost,
  });

  final AddCafeState state;

  /// Called when the user taps "Post". Hook up your submit/API call here.
  final void Function(BuildContext context, AddCafeState state)? onPost;

  @override
  State<Step4StoryPage> createState() => _Step4StoryPageState();
}

class _Step4StoryPageState extends State<Step4StoryPage> {
  static const _maxStoryLength = 400;
  late final TextEditingController _storyController;

  static const _textColor = Color(0xFF3E2A20);
  static const _backgroundColor = Color(0xFFFAF6EE);
  static const _cardColor = Color(0xFF8A6A50);

  @override
  void initState() {
    super.initState();
    _storyController = TextEditingController(text: widget.state.story)
      ..addListener(() => widget.state.setStory(_storyController.text));
    widget.state.addListener(_onStateChanged);
  }

  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    widget.state.removeListener(_onStateChanged);
    _storyController.dispose();
    super.dispose();
  }

  void _handlePost() {
    widget.onPost?.call(context, widget.state);
  }

  void _handleSkip() {
    // Last step — "Skip" exits the whole flow back to where it started.
    // Customize this (e.g. navigate to a specific home route) as needed.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final displayName =
    state.briefName.trim().isNotEmpty ? state.briefName : state.cafeName;
    final tags = [...state.vibes, ...state.features];
    final tagsLabel = tags.isEmpty ? '' : tags.take(2).join(', ');

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                StepFlowHeader(
                  currentStep: 4,
                  totalSteps: 4,
                  onSkip: _handleSkip,
                ),
                const SizedBox(height: 20),
                Text(
                  'Step 4',
                  style: TextStyle(
                    fontSize: 13,
                    color: _textColor.withOpacity(0.6),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Story',
                          style: GoogleFonts.playfairDisplay(
                            textStyle: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'What makes your coffee shop special ?',
                          style: TextStyle(
                            fontSize: 13,
                            color: _textColor.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3ECE1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextField(
                                controller: _storyController,
                                maxLines: 5,
                                maxLength: _maxStoryLength,
                                buildCounter: (context,
                                    {required currentLength,
                                      required isFocused,
                                      maxLength}) =>
                                null,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: _textColor,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Write your ideas here ...',
                                  hintStyle: TextStyle(
                                    color: _textColor.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              Text(
                                '${_storyController.text.length}/$_maxStoryLength',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _textColor.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Preview',
                          style: GoogleFonts.playfairDisplay(
                            textStyle: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          height: 220,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _cardColor,
                            borderRadius: BorderRadius.circular(20),
                            image: state.imagePath != null
                                ? DecorationImage(
                              image: FileImage(File(state.imagePath!)),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.25),
                                BlendMode.darken,
                              ),
                            )
                                : null,
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star,
                                          size: 14, color: Color(0xFFF5B301)),
                                      SizedBox(width: 4),
                                      Text(
                                        '4.8',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      displayName.isEmpty
                                          ? 'Your cafe name'
                                          : displayName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      tagsLabel.isEmpty
                                          ? (state.area.isEmpty
                                          ? 'Area · Features'
                                          : state.area)
                                          : '350 m away · $tagsLabel',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                FlowPrimaryButton(
                  label: 'Post',
                  onPressed: state.step4Valid ? _handlePost : null,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      ),
    );
  }
}