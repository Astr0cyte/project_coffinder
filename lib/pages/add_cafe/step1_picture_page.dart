import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/image_upload_service.dart';
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

  File? _pickedFile;
  bool _isUploading = false;

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

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    final file = File(picked.path);
    setState(() {
      _pickedFile = file;
      _isUploading = true;
    });

    try {
      final url = await ImageUploadService.instance.uploadImage(file);
      widget.state.setImageUrl(url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _handleRemoveImage() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Remove this photo?',
          style: GoogleFonts.quicksand(
            color: _textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'You can upload a different image afterwards.',
          style: GoogleFonts.quicksand(color: _textColor.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.quicksand(color: _textColor.withOpacity(0.6)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: GoogleFonts.quicksand(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() => _pickedFile = null);
      widget.state.setImageUrl(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final bool hasImage = state.imageUrl != null && state.imageUrl!.isNotEmpty;
    final bool canContinue = hasImage && !_isUploading;

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
                Text(
                  'Step 1',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Picture of café',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF402F11),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'First view of cafe',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: _textColor.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: _isUploading
                              ? null
                              : (widget.onPickImage ?? _pickAndUploadImage),
                          onLongPress: (!hasImage || _isUploading)
                              ? null
                              : _handleRemoveImage,
                          child: Container(
                            width: double.infinity,
                            height: 450,
                            decoration: BoxDecoration(
                              color: const Color(0xffF7F2E8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xffDCCFB8),
                                width: 1.5,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: _buildContent(hasImage),
                          ),
                        ),
                        if (_isUploading) ...[
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
                                        style: GoogleFonts.quicksand(
                                          fontSize: 13,
                                          color: _textColor.withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4),
                                        child: const LinearProgressIndicator(
                                          minHeight: 4,
                                          backgroundColor: Color(0xFFE3DACB),
                                          valueColor:
                                              AlwaysStoppedAnimation(
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                FlowPrimaryButton(
                  label: 'Continue',
                  onPressed: canContinue ? _handleContinue : null,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool hasImage) {
    if (!hasImage && _pickedFile == null) {
      return Center(
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
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: _textColor.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Support JPG, PNG ...',
              style: GoogleFonts.quicksand(
                fontSize: 12,
                color: _textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: hasImage
                ? Image.network(
                    widget.state.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(Icons.image,
                          size: 40, color: _textColor.withOpacity(0.3)),
                    ),
                  )
                : Image.file(_pickedFile!, fit: BoxFit.cover),
          ),
        ),
        if (_isUploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          )
        else
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
                  child: Row(
                    children: [
                      const Icon(Icons.touch_app_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Hold to remove',
                        style: GoogleFonts.quicksand(
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
    );
  }
}
