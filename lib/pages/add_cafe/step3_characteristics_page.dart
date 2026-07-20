import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../states/add_cafe_state.dart';
import '../../widgets/step_flow_header.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/flow_primary_button.dart';
import 'step4_story_page.dart';

class Step3CharacteristicsPage extends StatefulWidget {
  const Step3CharacteristicsPage({super.key, required this.state});

  final AddCafeState state;

  @override
  State<Step3CharacteristicsPage> createState() =>
      _Step3CharacteristicsPageState();
}

class _Step3CharacteristicsPageState extends State<Step3CharacteristicsPage> {
  static const _featureOptions = [
    'Air conditioned',
    'Pets',
    'Quiet',
    'Wi-Fi',
    'Parking',
    'Friendly staff',
  ];

  final List<String> _customFeatures = [];

  static const _textColor = Color(0xFF7E654C);
  static const _backgroundColor = Color(0xFFFAF9F4);

  @override
  void initState() {
    super.initState();
    widget.state.addListener(_onStateChanged);
  }

  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    widget.state.removeListener(_onStateChanged);
    super.dispose();
  }

  // Hàm hiển thị Popup thêm Feature
  void _showAddCustomItemDialog() {
    const type = 'Feature';
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Add custom $type',
            style: const TextStyle(color: _textColor, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: textController,
            style: const TextStyle(color: _textColor),
            decoration: InputDecoration(
              hintText: 'Enter new $type...',
              hintStyle: TextStyle(color: _textColor.withOpacity(0.5)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _textColor.withOpacity(0.3)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: _textColor, width: 1.5),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: _textColor.withOpacity(0.6))),
            ),
            TextButton(
              onPressed: () {
                final val = textController.text.trim();
                if (val.isNotEmpty) {
                  setState(() {
                    if (!_customFeatures.contains(val) && !_featureOptions.contains(val)) {
                      _customFeatures.add(val);
                      if (!widget.state.features.contains(val)) {
                        widget.state.toggleFeature(val);
                      }
                    }
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _handleContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Step4StoryPage(state: widget.state),
      ),
    );
  }

  void _handleSkip() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Step4StoryPage(state: widget.state),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.playfairTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 26),
                StepFlowHeader(
                  currentStep: 3,
                  totalSteps: 4,
                  onSkip: _handleSkip,
                ),
                const SizedBox(height: 20),
                Text(
                  'Step 3',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Cafe's characteristics",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w500,
                    color: _textColor,
                  ),
                ),
                Text(
                  'Features',
                  style: TextStyle(
                    fontSize: 18,
                    color: _textColor.withOpacity(0.8),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'FEATURE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _textColor.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ..._featureOptions.map((option) {
                              final isSelected = state.features.contains(option);
                              return GestureDetector(
                                onTap: () => state.toggleFeature(option),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                                  decoration: BoxDecoration(
                                    color: isSelected ? _textColor : const Color(0xFFF2EFDE),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : _textColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            ..._customFeatures.map((feature) {
                              final isSelected = state.features.contains(feature);
                              return InputChip(
                                label: Text(feature),
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : _textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                backgroundColor: isSelected ? _textColor : Colors.transparent,
                                selectedColor: _textColor,
                                deleteIconColor: isSelected ? Colors.white70 : _textColor.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected ? _textColor : _textColor.withOpacity(0.3),
                                  ),
                                ),
                                onSelected: (_) => state.toggleFeature(feature),
                                onDeleted: () {
                                  setState(() {
                                    _customFeatures.remove(feature);
                                    if (state.features.contains(feature)) {
                                      state.toggleFeature(feature);
                                    }
                                  });
                                },
                              );
                            }),
                            GestureDetector(
                              onTap: () => _showAddCustomItemDialog(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2EFDE),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'More ...',
                                  style: TextStyle(
                                    color: _textColor.withOpacity(0.8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                FlowPrimaryButton(
                  label: 'Continue',
                  onPressed: state.step3Valid ? _handleContinue : null,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}