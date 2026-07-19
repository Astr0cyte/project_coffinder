import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../states/add_cafe_state.dart';
import '../../widgets/step_flow_header.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/flow_primary_button.dart';
import '../../widgets/labeled_underline_field.dart';
import 'step3_characteristics_page.dart';

class Step2InformationPage extends StatefulWidget {
  const Step2InformationPage({super.key, required this.state});

  final AddCafeState state;

  @override
  State<Step2InformationPage> createState() => _Step2InformationPageState();
}

class _Step2InformationPageState extends State<Step2InformationPage> {
  late final TextEditingController _cafeNameController;
  late final TextEditingController _areaController;
  late final TextEditingController _addressController;
  late final TextEditingController _openTimeController;

  static const _textColor = Color(0xFF7E654C);
  static const _backgroundColor = Color(0xFFFAF9F4);

  @override
  void initState() {
    super.initState();
    final state = widget.state;
    _cafeNameController = TextEditingController(text: state.cafeName)
      ..addListener(() => state.setCafeName(_cafeNameController.text));
    _areaController = TextEditingController(text: state.area)
      ..addListener(() => state.setArea(_areaController.text));
    _addressController = TextEditingController(text: state.address)
      ..addListener(() => state.setAddress(_addressController.text));
    _openTimeController = TextEditingController(text: state.openTime)
      ..addListener(() => state.setOpenTime(_openTimeController.text));
    state.addListener(_onStateChanged);
  }

  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    widget.state.removeListener(_onStateChanged);
    _cafeNameController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    _openTimeController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Step3CharacteristicsPage(state: widget.state),
      ),
    );
  }

  void _handleSkip() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Step3CharacteristicsPage(state: widget.state),
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
                  currentStep: 2,
                  totalSteps: 4,
                  onSkip: _handleSkip,
                ),
                const SizedBox(height: 20),
                Text(
                  'Step 2',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Café \ninformation',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF402F11),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Address, opening hours, etc',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: _textColor.withOpacity(0.8),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        LabeledUnderlineField(
                          label: 'Cafe Name',
                          required: true,
                          controller: _cafeNameController,
                          hintText: 'Phuc Long...',
                        ),
                        const SizedBox(height: 28),
                        LabeledUnderlineField(
                          label: 'Area',
                          required: true,
                          controller: _areaController,
                          hintText: 'HCMC ...',
                        ),
                        const SizedBox(height: 28),
                        LabeledUnderlineField(
                          label: 'Address',
                          required: true,
                          controller: _addressController,
                          hintText: 'District 1 ...',
                        ),
                        const SizedBox(height: 28),
                        LabeledUnderlineField(
                          label: 'Open Time',
                          required: true,
                          controller: _openTimeController,
                          hintText: '7:00 am - 9:00 pm...',
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                FlowPrimaryButton(
                  label: 'Continue',
                  onPressed: state.step2Valid ? _handleContinue : null,
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