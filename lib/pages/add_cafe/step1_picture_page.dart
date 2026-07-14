import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../states/add_cafe_state.dart';
import '../../widgets/step_flow_header.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/flow_primary_button.dart';
import '../../widgets/labeled_underline_field.dart';
import 'step2_information_page.dart';

class Step1PicturePage extends StatefulWidget {
  const Step1PicturePage({
    super.key,
    required this.state,
    this.onPickImage,
  });

  /// Shared state across the whole 4-step flow.
  final AddCafeState state;

  /// Called when the user taps the dropzone. If null, defaults to
  /// opening the device gallery via `image_picker`.
  final VoidCallback? onPickImage;

  @override
  State<Step1PicturePage> createState() => _Step1PicturePageState();
}

class _Step1PicturePageState extends State<Step1PicturePage> {
  late final TextEditingController _briefNameController;

  static const _textColor = Color(0xFF7E654C  );
  static const _backgroundColor = Color(0xFFFAF6EE);

  @override
  void initState() {
    super.initState();
    _briefNameController = TextEditingController(text: widget.state.briefName)
      ..addListener(() => widget.state.setBriefName(_briefNameController.text));
    widget.state.addListener(_onStateChanged);
  }

  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    widget.state.removeListener(_onStateChanged);
    _briefNameController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Step2InformationPage(state: widget.state),
      ),
    );
  }

  void _handleSkip() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Step2InformationPage(state: widget.state),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    widget.state.setUploading(true, progress: 0);
    // Simulated upload progress — replace with real upload progress
    // callbacks if you're sending the file to a server.
    for (var i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      widget.state.setUploading(true, progress: i / 5);
    }
    widget.state.setImagePath(picked.path);
    widget.state.setUploading(false, progress: 1);
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
                const SizedBox(height: 26),
                StepFlowHeader(
                  currentStep: 1,
                  totalSteps: 4,
                  onSkip: _handleSkip,
                ),
                const SizedBox(height: 20),
                Text(
                  'Step 1',
                  style: TextStyle(
                    fontSize: 13,
                    color: _textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Picture of café',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'First view of cafe',
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
                        GestureDetector(
                          onTap: widget.onPickImage ?? _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 220,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3ECE1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFC9B892),
                                width: 1.5,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: state.imagePath == null
                                ? Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 36,
                                    color: _textColor.withOpacity(0.4),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Drop your image here, or Browse',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _textColor.withOpacity(0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Support JPG, PNG ...',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _textColor.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                File(state.imagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: _textColor.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (state.isUploading) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3ECE1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Uploading...',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: _textColor.withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: state.uploadProgress,
                                          minHeight: 4,
                                          backgroundColor:
                                          const Color(0xFFE3DACB),
                                          valueColor:
                                          const AlwaysStoppedAnimation(
                                            Color(0xFF8A6A50),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(Icons.pause_circle_outline,
                                    color: _textColor.withOpacity(0.6)),
                                const SizedBox(width: 6),
                                Icon(Icons.close,
                                    color: _textColor.withOpacity(0.6),
                                    size: 20),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        LabeledUnderlineField(
                          label: 'BRIEF NAME - DISPLAY IN CARD',
                          controller: _briefNameController,
                          hintText: 'Ex: Phuc Long ...',
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                FlowPrimaryButton(
                  label: 'Continue',
                  onPressed: state.step1Valid ? _handleContinue : null,
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