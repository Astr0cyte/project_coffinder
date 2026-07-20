// // import 'dart:io';
// // import 'dart:ui'; // Đã thêm import này để dùng ImageFilter cho hiệu ứng Blur
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:image_picker/image_picker.dart';
// // import '../../states/add_cafe_state.dart';
// // import '../../widgets/step_flow_header.dart';
// // import '../../widgets/app_bottom_nav_bar.dart';
// // import '../../widgets/flow_primary_button.dart';
// // import 'step2_information_page.dart';
// //
// // class Step1PicturePage extends StatefulWidget {
// //   const Step1PicturePage({
// //     super.key,
// //     required this.state,
// //     this.onPickImage,
// //   });
// //
// //   /// Shared state across the whole 4-step flow.
// //   final AddCafeState state;
// //
// //   /// Called when the user taps the dropzone. If null, defaults to
// //   /// opening the device gallery via `image_picker`.
// //   final VoidCallback? onPickImage;
// //
// //   @override
// //   State<Step1PicturePage> createState() => _Step1PicturePageState();
// // }
// //
// // class _Step1PicturePageState extends State<Step1PicturePage> {
// //   static const _textColor = Color(0xFF7E654C);
// //   static const _backgroundColor = Color(0xFFFAF9F4);
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     widget.state.addListener(_onStateChanged);
// //   }
// //
// //   void _onStateChanged() => setState(() {});
// //
// //   @override
// //   void dispose() {
// //     widget.state.removeListener(_onStateChanged);
// //     super.dispose();
// //   }
// //
// //   void _handleContinue() {
// //     Navigator.of(context).push(
// //       MaterialPageRoute(
// //         builder: (_) => Step2InformationPage(state: widget.state),
// //       ),
// //     );
// //   }
// //
// //   void _handleSkip() {
// //     Navigator.of(context).push(
// //       MaterialPageRoute(
// //         builder: (_) => Step2InformationPage(state: widget.state),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _pickImage() async {
// //     final picker = ImagePicker();
// //     final picked = await picker.pickImage(
// //       source: ImageSource.gallery,
// //       imageQuality: 85,
// //     );
// //     if (picked == null) return;
// //
// //     widget.state.setUploading(true, progress: 0);
// //     // Simulated upload progress — replace with real upload progress
// //     // callbacks if you're sending the file to a server.
// //     for (var i = 1; i <= 5; i++) {
// //       await Future.delayed(const Duration(milliseconds: 120));
// //       if (!mounted) return;
// //       widget.state.setUploading(true, progress: i / 5);
// //     }
// //     widget.state.setImagePath(picked.path);
// //     widget.state.setUploading(false, progress: 1);
// //   }
// //
// //   /// Long-press on an already-uploaded image asks for confirmation, then
// //   /// clears it so the user can pick a different one.
// //   Future<void> _handleLongPressImage() async {
// //     if (widget.state.imagePath == null) return;
// //
// //     final shouldDelete = await showDialog<bool>(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         backgroundColor: _backgroundColor,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(16),
// //         ),
// //         title: const Text(
// //           'Remove this photo?',
// //           style: TextStyle(color: _textColor, fontWeight: FontWeight.w600),
// //         ),
// //         content: Text(
// //           'You can upload a different image afterwards.',
// //           style: TextStyle(color: _textColor.withOpacity(0.7)),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.of(context).pop(false),
// //             child: Text(
// //               'Cancel',
// //               style: TextStyle(color: _textColor.withOpacity(0.6)),
// //             ),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.of(context).pop(true),
// //             child: const Text(
// //               'Delete',
// //               style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //
// //     if (shouldDelete == true) {
// //       widget.state.setImagePath(null);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final state = widget.state;
// //
// //     // Nút Continue sáng lên nếu đã có hình (khác null) và không đang upload.
// //     final bool canContinue = state.imagePath != null && !state.isUploading;
// //
// //     return Theme(
// //       data: Theme.of(context).copyWith(
// //         textTheme: GoogleFonts.playfairTextTheme(Theme.of(context).textTheme),
// //       ),
// //       child: Scaffold(
// //         backgroundColor: _backgroundColor,
// //         body: SafeArea(
// //           child: Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 35),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const SizedBox(height: 26),
// //                 StepFlowHeader(
// //                   currentStep: 1,
// //                   totalSteps: 4,
// //                   onSkip: _handleSkip,
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Text(
// //                   'Step 1',
// //                   style: TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.w500,
// //                     color: _textColor,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 5),
// //                 const Text(
// //                   'Picture of café',
// //                   style: TextStyle(
// //                     fontSize: 45,
// //                     fontWeight: FontWeight.w500,
// //                     color: _textColor,
// //                   ),
// //                 ),
// //                 Text(
// //                   'First view of cafe',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     color: _textColor.withOpacity(0.8),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   child: SingleChildScrollView(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const SizedBox(height: 5),
// //                         GestureDetector(
// //                           onTap: widget.onPickImage ?? _pickImage,
// //                           onLongPress: state.imagePath == null
// //                               ? null
// //                               : _handleLongPressImage,
// //                           child: Container(
// //                             width: double.infinity,
// //                             height: 450,
// //                             decoration: BoxDecoration(
// //                               color: const Color(0xFFF2EFDE),
// //                               borderRadius: BorderRadius.circular(16),
// //                               border: Border.all(
// //                                 color: const Color(0xFFC9B892),
// //                                 width: 1.5,
// //                                 style: BorderStyle.solid,
// //                               ),
// //                             ),
// //                             child: state.imagePath == null
// //                                 ? Center(
// //                               child: Column(
// //                                 mainAxisAlignment:
// //                                 MainAxisAlignment.center,
// //                                 children: [
// //                                   Icon(
// //                                     Icons.cloud_upload_outlined,
// //                                     size: 66,
// //                                     color: _textColor.withOpacity(0.4),
// //                                   ),
// //                                   const SizedBox(height: 12),
// //                                   Text(
// //                                     'Drop your image here, or Browse',
// //                                     style: TextStyle(
// //                                       fontSize: 18,
// //                                       color: _textColor.withOpacity(0.9),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 2),
// //                                   Text(
// //                                     'Support JPG, PNG ...',
// //                                     style: TextStyle(
// //                                       fontSize: 14,
// //                                       color: _textColor.withOpacity(0.6),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             )
// //                                 : Stack(
// //                               children: [
// //                                 ClipRRect(
// //                                   borderRadius: BorderRadius.circular(14),
// //                                   child: SizedBox(
// //                                     width: double.infinity,
// //                                     height: double.infinity,
// //                                     child: Image.file(
// //                                       File(state.imagePath!),
// //                                       fit: BoxFit.cover,
// //                                       errorBuilder: (_, __, ___) => Center(
// //                                         child: Icon(
// //                                           Icons.image,
// //                                           size: 40,
// //                                           color:
// //                                           _textColor.withOpacity(0.3),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 // Đã cập nhật lại nhãn thành blur (glassmorphism) và màu _textColor
// //                                 Positioned(
// //                                   right: 12,
// //                                   top: 12,
// //                                   child: ClipRRect(
// //                                     borderRadius: BorderRadius.circular(20),
// //                                     child: BackdropFilter(
// //                                       filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), // Mức độ làm mờ
// //                                       child: Container(
// //                                         padding: const EdgeInsets.symmetric(
// //                                           horizontal: 12,
// //                                           vertical: 6,
// //                                         ),
// //                                         decoration: BoxDecoration(
// //                                           color: _textColor.withOpacity(0.5), // Màu chủ đạo + độ trong suốt 50%
// //                                         ),
// //                                         child: const Row(
// //                                           children: [
// //                                             Icon(
// //                                                 Icons.touch_app_rounded,
// //                                                 color: Colors.white,
// //                                                 size: 16
// //                                             ),
// //                                             SizedBox(width: 4),
// //                                             Text(
// //                                               'Hold to remove',
// //                                               style: TextStyle(
// //                                                 color: Colors.white,
// //                                                 fontSize: 12,
// //                                                 fontWeight: FontWeight.w500,
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                         if (state.isUploading) ...[
// //                           const SizedBox(height: 12),
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(
// //                               horizontal: 14,
// //                               vertical: 10,
// //                             ),
// //                             decoration: BoxDecoration(
// //                               color: const Color(0xFFF3ECE1),
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                             child: Row(
// //                               children: [
// //                                 Expanded(
// //                                   child: Column(
// //                                     crossAxisAlignment:
// //                                     CrossAxisAlignment.start,
// //                                     children: [
// //                                       Text(
// //                                         'Uploading...',
// //                                         style: TextStyle(
// //                                           fontSize: 13,
// //                                           color: _textColor.withOpacity(0.7),
// //                                         ),
// //                                       ),
// //                                       const SizedBox(height: 6),
// //                                       ClipRRect(
// //                                         borderRadius:
// //                                         BorderRadius.circular(4),
// //                                         child: LinearProgressIndicator(
// //                                           value: state.uploadProgress,
// //                                           minHeight: 4,
// //                                           backgroundColor:
// //                                           const Color(0xFFE3DACB),
// //                                           valueColor:
// //                                           const AlwaysStoppedAnimation(
// //                                             Color(0xFF8A6A50),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                                 const SizedBox(width: 10),
// //                                 Icon(Icons.pause_circle_outline,
// //                                     color: _textColor.withOpacity(0.6)),
// //                                 const SizedBox(width: 6),
// //                                 Icon(Icons.close,
// //                                     color: _textColor.withOpacity(0.6),
// //                                     size: 20),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                         const SizedBox(height: 20),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 FlowPrimaryButton(
// //                   label: 'Continue',
// //                   onPressed: canContinue ? _handleContinue : null,
// //                 ),
// //                 const SizedBox(height: 12),
// //               ],
// //             ),
// //           ),
// //         ),
// //         bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../states/add_cafe_state.dart';
// import '../../widgets/step_flow_header.dart';
// import '../../widgets/app_bottom_nav_bar.dart';
// import '../../widgets/flow_primary_button.dart';
// import 'step2_information_page.dart';
//
// class Step1PicturePage extends StatefulWidget {
//   const Step1PicturePage({super.key, required this.state});
//
//   final AddCafeState state;
//
//   @override
//   State<Step1PicturePage> createState() => _Step1PicturePageState();
// }
//
// class _Step1PicturePageState extends State<Step1PicturePage> {
//   static const _textColor = Color(0xFF7E654C);
//   static const _backgroundColor = Color(0xFFFAF9F4);
//
//   @override
//   void initState() {
//     super.initState();
//     widget.state.addListener(_onStateChanged);
//   }
//
//   void _onStateChanged() => setState(() {});
//
//   @override
//   void dispose() {
//     widget.state.removeListener(_onStateChanged);
//     super.dispose();
//   }
//
//   void _handleContinue() {
//     Navigator.of(context).push(
//       MaterialPageRoute(builder: (_) => Step2InformationPage(state: widget.state)),
//     );
//   }
//
//   void _handleSkip() {
//     Navigator.of(context).push(
//       MaterialPageRoute(builder: (_) => Step2InformationPage(state: widget.state)),
//     );
//   }
//
//   /// Mở dialog cho người dùng dán link ảnh, thay vì mở gallery.
//   Future<void> _showUrlInputDialog() async {
//     final controller = TextEditingController(text: widget.state.imageUrl ?? '');
//
//     final result = await showDialog<String>(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: _backgroundColor,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'Dán link ảnh quán',
//           style: TextStyle(color: _textColor, fontWeight: FontWeight.w600),
//         ),
//         content: TextField(
//           controller: controller,
//           autofocus: true,
//           keyboardType: TextInputType.url,
//           style: const TextStyle(color: _textColor),
//           decoration: InputDecoration(
//             hintText: 'https://example.com/anh-quan.jpg',
//             hintStyle: TextStyle(color: _textColor.withOpacity(0.4)),
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: _textColor.withOpacity(0.3)),
//             ),
//             focusedBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: _textColor, width: 1.5),
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('Cancel', style: TextStyle(color: _textColor.withOpacity(0.6))),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(controller.text.trim()),
//             child: const Text(
//               'Dùng ảnh này',
//               style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//
//     if (result != null && result.isNotEmpty) {
//       widget.state.setImageUrl(result);
//     }
//   }
//
//   Future<void> _handleRemoveImage() async {
//     final shouldDelete = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: _backgroundColor,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'Remove this photo?',
//           style: TextStyle(color: _textColor, fontWeight: FontWeight.w600),
//         ),
//         content: Text(
//           'Bạn có thể dán link ảnh khác sau đó.',
//           style: TextStyle(color: _textColor.withOpacity(0.7)),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text('Cancel', style: TextStyle(color: _textColor.withOpacity(0.6))),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
//           ),
//         ],
//       ),
//     );
//
//     if (shouldDelete == true) {
//       widget.state.setImageUrl(null);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = widget.state;
//     final bool canContinue = state.imageUrl != null && state.imageUrl!.isNotEmpty;
//
//     return Theme(
//       data: Theme.of(context).copyWith(
//         textTheme: GoogleFonts.playfairTextTheme(Theme.of(context).textTheme),
//       ),
//       child: Scaffold(
//         backgroundColor: _backgroundColor,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 35),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 26),
//                 StepFlowHeader(currentStep: 1, totalSteps: 4, onSkip: _handleSkip),
//                 const SizedBox(height: 20),
//                 Text('Step 1', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: _textColor)),
//                 const SizedBox(height: 5),
//                 const Text('Picture of café', style: TextStyle(fontSize: 45, fontWeight: FontWeight.w500, color: _textColor)),
//                 Text('First view of cafe', style: TextStyle(fontSize: 18, color: _textColor.withOpacity(0.8))),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 5),
//                         GestureDetector(
//                           onTap: _showUrlInputDialog,
//                           onLongPress: state.imageUrl == null ? null : _handleRemoveImage,
//                           child: Container(
//                             width: double.infinity,
//                             height: 450,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFF2EFDE),
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(color: const Color(0xFFC9B892), width: 1.5),
//                             ),
//                             child: (state.imageUrl == null || state.imageUrl!.isEmpty)
//                                 ? Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.link, size: 66, color: _textColor.withOpacity(0.4)),
//                                   const SizedBox(height: 12),
//                                   Text(
//                                     'Nhấn để dán link ảnh',
//                                     style: TextStyle(fontSize: 18, color: _textColor.withOpacity(0.9)),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     'Dán link ảnh từ internet (jpg, png...)',
//                                     style: TextStyle(fontSize: 14, color: _textColor.withOpacity(0.6)),
//                                   ),
//                                 ],
//                               ),
//                             )
//                                 : Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(14),
//                                   child: SizedBox(
//                                     width: double.infinity,
//                                     height: double.infinity,
//                                     child: Image.network(
//                                       state.imageUrl!,
//                                       fit: BoxFit.cover,
//                                       loadingBuilder: (context, child, progress) {
//                                         if (progress == null) return child;
//                                         return const Center(child: CircularProgressIndicator());
//                                       },
//                                       errorBuilder: (_, __, ___) => Center(
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Icon(Icons.broken_image_outlined, size: 40, color: _textColor.withOpacity(0.3)),
//                                             const SizedBox(height: 8),
//                                             Text(
//                                               'Link ảnh không hợp lệ',
//                                               style: TextStyle(fontSize: 13, color: _textColor.withOpacity(0.6)),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   right: 12,
//                                   top: 12,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                     decoration: BoxDecoration(
//                                       color: _textColor.withOpacity(0.7),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: const Row(
//                                       children: [
//                                         Icon(Icons.touch_app_rounded, color: Colors.white, size: 16),
//                                         SizedBox(width: 4),
//                                         Text(
//                                           'Giữ để xoá',
//                                           style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//                 FlowPrimaryButton(label: 'Continue', onPressed: canContinue ? _handleContinue : null),
//                 const SizedBox(height: 12),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/image_upload_service.dart';
import '../../states/add_cafe_state.dart';
import '../../widgets/step_flow_header.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/flow_primary_button.dart';
import 'step2_information_page.dart';

class Step1PicturePage extends StatefulWidget {
  const Step1PicturePage({super.key, required this.state});

  final AddCafeState state;

  @override
  State<Step1PicturePage> createState() => _Step1PicturePageState();
}

class _Step1PicturePageState extends State<Step1PicturePage> {
  static const _textColor = Color(0xFF7E654C);
  static const _backgroundColor = Color(0xFFFAF9F4);

  // Ảnh local dùng để preview NGAY trong lúc đang upload (chưa có URL).
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
      MaterialPageRoute(builder: (_) => Step2InformationPage(state: widget.state)),
    );
  }

  void _handleSkip() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Step2InformationPage(state: widget.state)),
    );
  }

  /// Chọn ảnh từ gallery -> upload lên imgbb -> lưu URL vào AddCafeState.
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
          SnackBar(content: Text('Upload ảnh thất bại: $e')),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            child: Text('Cancel', style: TextStyle(color: _textColor.withOpacity(0.6))),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
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
                StepFlowHeader(currentStep: 1, totalSteps: 4, onSkip: _handleSkip),
                const SizedBox(height: 20),
                Text('Step 1', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: _textColor)),
                const SizedBox(height: 5),
                const Text('Picture of café', style: TextStyle(fontSize: 45, fontWeight: FontWeight.w500, color: _textColor)),
                Text('First view of cafe', style: TextStyle(fontSize: 18, color: _textColor.withOpacity(0.8))),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: _isUploading ? null : _pickAndUploadImage,
                          onLongPress: (!hasImage || _isUploading) ? null : _handleRemoveImage,
                          child: Container(
                            width: double.infinity,
                            height: 450,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2EFDE),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFC9B892), width: 1.5),
                            ),
                            child: _buildContent(hasImage),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                FlowPrimaryButton(label: 'Continue', onPressed: canContinue ? _handleContinue : null),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      ),
    );
  }

  Widget _buildContent(bool hasImage) {
    // Chưa chọn ảnh gì cả.
    if (!hasImage && _pickedFile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 66, color: _textColor.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text('Drop your image here, or Browse', style: TextStyle(fontSize: 18, color: _textColor.withOpacity(0.9))),
            const SizedBox(height: 2),
            Text('Support JPG, PNG ...', style: TextStyle(fontSize: 14, color: _textColor.withOpacity(0.6))),
          ],
        ),
      );
    }

    // Đã có ảnh (local trong lúc upload, hoặc URL sau khi upload xong).
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
                child: Icon(Icons.image, size: 40, color: _textColor.withOpacity(0.3)),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 10),
                    Text('Đang tải ảnh lên...', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
              ),
            ),
          )
        else
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _textColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.touch_app_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text('Hold to remove', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}