import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../states/add_cafe_state.dart';
import '../../widgets/step_flow_header.dart';
import '../../widgets/flow_primary_button.dart';
import 'step2_information_page.dart';

class Step1PicturePage extends StatefulWidget {
  const Step1PicturePage({
    super.key,
    required this.state,
    this.onPickImage,
  });

  final AddCafeState state;
  final VoidCallback? onPickImage;

  @override
  State<Step1PicturePage> createState() => _Step1PicturePageState();
}

class _Step1PicturePageState extends State<Step1PicturePage> {
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
    for (var i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      widget.state.setUploading(true, progress: i / 5);
    }
    widget.state.setImagePath(picked.path);
    widget.state.setUploading(false, progress: 1);
  }

  Future<void> _handleLongPressImage() async {
    if (widget.state.imagePath == null) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Remove this photo?',
          style: TextStyle(color: _textColor, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'You can upload a different image afterwards.',
          style: TextStyle(color: _textColor.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: _textColor.withOpacity(0.6)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      widget.state.setImagePath(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final bool canContinue = state.imagePath != null && !state.isUploading;

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
                  currentStep: 1,
                  totalSteps: 4,
                  onSkip: _handleSkip,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Step 1',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Picture of café',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w500,
                    color: _textColor,
                  ),
                ),
                Text(
                  'First view of cafe',
                  style: TextStyle(
                    fontSize: 18,
                    color: _textColor.withOpacity(0.8),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: widget.onPickImage ?? _pickImage,
                          onLongPress: state.imagePath == null
                              ? null
                              : _handleLongPressImage,
                          child: Container(
                            width: double.infinity,
                            height: 450,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2EFDE),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 66,
                                    color: _textColor.withOpacity(0.4),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Drop your image here, or Browse',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: _textColor.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Support JPG, PNG ...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _textColor.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
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
                                Positioned(
                                  right: 12,
                                  top: 12,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _textColor.withOpacity(0.5),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                                Icons.touch_app_rounded,
                                                color: Colors.white,
                                                size: 16
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Hold to remove',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: state.uploadProgress,
                                          minHeight: 4,
                                          backgroundColor: const Color(0xFFE3DACB),
                                          valueColor: const AlwaysStoppedAnimation(
                                            Color(0xFF8A6A50),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(Icons.pause_circle_outline, color: _textColor.withOpacity(0.6)),
                                const SizedBox(width: 6),
                                Icon(Icons.close, color: _textColor.withOpacity(0.6), size: 20),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FlowPrimaryButton(
                          label: 'Continue',
                          onPressed: canContinue ? _handleContinue : null,
                        ),
                      ],
                    ),
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