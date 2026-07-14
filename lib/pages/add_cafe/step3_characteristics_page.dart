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

  // Danh sách lưu trữ các Vibe/Feature do người dùng tự thêm
  final List<String> _customVibes = [];
  final List<String> _customFeatures = [];

  late final List<TextEditingController> _drinkControllers;

  final ScrollController _drinksScrollController = ScrollController();

  static const _textColor = Color(0xFF7E654C);
  static const _backgroundColor = Color(0xFFFAF9F4);

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
    _drinksScrollController.dispose();
    super.dispose();
  }

  void _addDrinkSlot() {
    widget.state.addSignatureDrinkSlot();
    _drinkControllers.add(TextEditingController());
    setState(() {});
  }

  // Hàm xoá món uống
  void _removeDrinkSlot(int index) {
    setState(() {
      _drinkControllers[index].dispose();
      _drinkControllers.removeAt(index);
    });
    // Đồng bộ với State: Xoá phần tử tương ứng trong state
    if (index < widget.state.signatureDrinks.length) {
      widget.state.signatureDrinks.removeAt(index);
    }
  }

  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final controller = _drinkControllers.removeAt(oldIndex);
      _drinkControllers.insert(newIndex, controller);
    });

    for (int i = 0; i < _drinkControllers.length; i++) {
      widget.state.setSignatureDrink(i, _drinkControllers[i].text);
    }
  }

  // Hàm hiển thị Popup thêm Vibe / Feature
  void _showAddCustomItemDialog(String type) {
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
                    if (type == 'Vibe') {
                      if (!_customVibes.contains(val) && !_vibeOptions.contains(val)) {
                        _customVibes.add(val);
                        if (!widget.state.vibes.contains(val)) {
                          widget.state.toggleVibe(val); // Tự động chọn luôn sau khi thêm
                        }
                      }
                    } else if (type == 'Feature') {
                      if (!_customFeatures.contains(val) && !_featureOptions.contains(val)) {
                        _customFeatures.add(val);
                        if (!widget.state.features.contains(val)) {
                          widget.state.toggleFeature(val);
                        }
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
    final bool hasManyDrinks = _drinkControllers.length > 2;

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
                  'Vibe, features, and best sellers',
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
                          trailing: GestureDetector(
                            onTap: () => _showAddCustomItemDialog('Vibe'),
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
                        ),
                        // Nơi hiển thị các Vibe tự thêm (có khả năng xoá)
                        if (_customVibes.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _customVibes.map((vibe) {
                              final isSelected = state.vibes.contains(vibe);
                              return InputChip(
                                label: Text(vibe),
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
                                onSelected: (_) => state.toggleVibe(vibe),
                                onDeleted: () {
                                  setState(() {
                                    _customVibes.remove(vibe);
                                    if (state.vibes.contains(vibe)) {
                                      state.toggleVibe(vibe); // Bỏ chọn trong state
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],

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
                          trailing: GestureDetector(
                            onTap: () => _showAddCustomItemDialog('Feature'),
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
                        ),
                        // Nơi hiển thị các Feature tự thêm (có khả năng xoá)
                        if (_customFeatures.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _customFeatures.map((feature) {
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
                            }).toList(),
                          ),
                        ],

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

                        Container(
                          constraints: BoxConstraints(
                            maxHeight: hasManyDrinks ? 160 : double.infinity,
                          ),
                          child: RawScrollbar(
                            controller: _drinksScrollController,
                            thumbVisibility: hasManyDrinks,
                            thumbColor: _textColor.withOpacity(0.4),
                            radius: const Radius.circular(8),
                            thickness: 4,
                            child: ReorderableListView.builder(
                              scrollController: _drinksScrollController,
                              shrinkWrap: true,
                              physics: hasManyDrinks
                                  ? const BouncingScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                              buildDefaultDragHandles: false,
                              itemCount: _drinkControllers.length,
                              onReorder: _handleReorder,
                              proxyDecorator: (child, index, animation) {
                                return Material(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: child,
                                );
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  key: ValueKey(_drinkControllers[index]),
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ReorderableDragStartListener(
                                        index: index,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 12),
                                          child: Icon(
                                            Icons.drag_indicator_rounded,
                                            size: 20,
                                            color: _textColor.withOpacity(0.4),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _textColor.withOpacity(0.5),
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
                                      // Thêm nút xoá ở cuối mỗi dòng Signature Drink
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(
                                            Icons.close,
                                            size: 18,
                                            color: _textColor.withOpacity(0.5)
                                        ),
                                        onPressed: () => _removeDrinkSlot(index),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: _addDrinkSlot,
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline,
                                  size: 18, color: _textColor.withOpacity(0.7)),
                              const SizedBox(width: 6),
                              Text(
                                'Add another',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _textColor.withOpacity(0.7),
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