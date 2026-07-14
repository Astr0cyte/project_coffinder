import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../states/add_cafe_state.dart';
import '../../widgets/step_flow_header.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/flow_primary_button.dart';
import '../../widgets/selectable_chip_group.dart';
import 'step4_story_page.dart';

class Step3CharacteristicsPage extends StatefulWidget {
  const Step3CharacteristicsPage({super.key, required this.state});

  final AddCafeState state;

  @override
  State<Step3CharacteristicsPage> createState() =>
      _Step3CharacteristicsPageState();
}

class _Step3CharacteristicsPageState extends State<Step3CharacteristicsPage> {
  static const _vibeOptions = [
    'Air conditioned',
    'Pets',
    'Quiet',
    'Wi-Fi',
    'Cozy',
    'Outdoor seating',
  ];
  static const _featureOptions = [
    'Air conditioned',
    'Pets',
    'Quiet',
    'Wi-Fi',
    'Parking',
    'Friendly staff',
  ];

  late final List<TextEditingController> _drinkControllers;

  static const _textColor = Color(0xFF3E2A20);
  static const _backgroundColor = Color(0xFFFAF6EE);

  @override
  void initState() {
    super.initState();
    _drinkControllers = widget.state.signatureDrinks
        .map((d) => TextEditingController(text: d))
        .toList();
    widget.state.addListener(_onStateChanged);
  }

  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    widget.state.removeListener(_onStateChanged);
    for (final c in _drinkControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addDrinkSlot() {
    widget.state.addSignatureDrinkSlot();
    _drinkControllers.add(TextEditingController());
    setState(() {});
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
                  currentStep: 3,
                  totalSteps: 4,
                  onSkip: _handleSkip,
                ),
                const SizedBox(height: 20),
                Text(
                  'Step 3',
                  style: TextStyle(
                    fontSize: 13,
                    color: _textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Cafe's characterisitcs",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Vibe, features, and best sellers',
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
                        const SizedBox(height: 20),
                        Text(
                          'VIBE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _textColor.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SelectableChipGroup(
                          options: _vibeOptions,
                          selected: state.vibes,
                          onToggle: state.toggleVibe,
                        ),
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
                        SelectableChipGroup(
                          options: _featureOptions,
                          selected: state.features,
                          onToggle: state.toggleFeature,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3ECE1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'More ...',
                              style: TextStyle(
                                color: _textColor.withOpacity(0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Signature drink',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(_drinkControllers.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _textColor.withOpacity(0.4),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _drinkControllers[index],
                                    onChanged: (value) => widget.state
                                        .setSignatureDrink(index, value),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: _textColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Ex: Chocolate ...',
                                      hintStyle: TextStyle(
                                        color: _textColor.withOpacity(0.35),
                                      ),
                                      isDense: true,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 8),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: _textColor.withOpacity(0.25),
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: _textColor.withOpacity(0.25),
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: _textColor,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        GestureDetector(
                          onTap: _addDrinkSlot,
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline,
                                  size: 18, color: _textColor.withOpacity(0.6)),
                              const SizedBox(width: 6),
                              Text(
                                'Add another',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _textColor.withOpacity(0.6),
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
                  label: 'Continue',
                  onPressed: state.step3Valid ? _handleContinue : null,
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