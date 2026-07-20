// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../states/add_cafe_state.dart';
// import '../../widgets/step_flow_header.dart';
// import '../../widgets/app_bottom_nav_bar.dart';
// import '../../widgets/flow_primary_button.dart';
//
// class Step4StoryPage extends StatefulWidget {
//   const Step4StoryPage({
//     super.key,
//     required this.state,
//     this.onPost,
//   });
//
//   final AddCafeState state;
//
//   /// Called when the user taps "Post". Hook up your submit/API call here.
//   final void Function(BuildContext context, AddCafeState state)? onPost;
//
//   @override
//   State<Step4StoryPage> createState() => _Step4StoryPageState();
// }
//
// class _Step4StoryPageState extends State<Step4StoryPage> {
//   static const _maxStoryLength = 400;
//   late final TextEditingController _storyController;
//
//   // Khai báo ScrollController cho TỔNG THỂ toàn bộ trang
//   final ScrollController _scrollController = ScrollController();
//
//   static const _textColor = Color(0xFF7E654C);
//   static const _backgroundColor = Color(0xFFFAF9F4);
//   static const _cardColor = Color(0xFF8A6A50);
//
//   @override
//   void initState() {
//     super.initState();
//     _storyController = TextEditingController(text: widget.state.story)
//       ..addListener(() => widget.state.setStory(_storyController.text));
//     widget.state.addListener(_onStateChanged);
//   }
//
//   void _onStateChanged() => setState(() {});
//
//   @override
//   void dispose() {
//     widget.state.removeListener(_onStateChanged);
//     _storyController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _handlePost() {
//     widget.onPost?.call(context, widget.state);
//   }
//
//   void _handleSkip() {
//     Navigator.of(context).popUntil((route) => route.isFirst);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = widget.state;
//     final displayName =
//     state.briefName.trim().isNotEmpty ? state.briefName : state.cafeName;
//     final tags = [...state.vibes, ...state.features];
//     final tagsLabel = tags.isEmpty ? '' : tags.take(2).join(', ');
//
//     return Theme(
//       data: Theme.of(context).copyWith(
//         textTheme: GoogleFonts.playfairTextTheme(Theme.of(context).textTheme),
//       ),
//       child: Scaffold(
//         backgroundColor: _backgroundColor,
//         body: SafeArea(
//           child: RawScrollbar(
//             controller: _scrollController,
//             thumbVisibility: true,
//             thumbColor: _textColor.withOpacity(0.5),
//             radius: const Radius.circular(8),
//             thickness: 5,
//             child: SingleChildScrollView(
//               controller: _scrollController,
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 35),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 26),
//                       StepFlowHeader(
//                         currentStep: 4,
//                         totalSteps: 4,
//                         onSkip: _handleSkip,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         'Step 4',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w500,
//                           color: _textColor,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       const Text(
//                         'Story',
//                         style: TextStyle(
//                           fontSize: 45,
//                           fontWeight: FontWeight.w500,
//                           color: _textColor,
//                         ),
//                       ),
//                       Text(
//                         'What makes your coffee shop special?',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: _textColor.withOpacity(0.8),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//
//                       // Khung nhập text (Story)
//                       Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF2EFDE),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         padding: const EdgeInsets.all(14),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             TextField(
//                               controller: _storyController,
//                               maxLines: 5,
//                               maxLength: _maxStoryLength,
//                               buildCounter: (context,
//                                   {required currentLength,
//                                     required isFocused,
//                                     maxLength}) =>
//                               null,
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 color: _textColor,
//                               ),
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: 'Write your ideas here ...',
//                                 hintStyle: TextStyle(
//                                   color: _textColor.withOpacity(0.4),
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${_storyController.text.length}/$_maxStoryLength',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: _textColor.withOpacity(0.5),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 28),
//
//                       const Text(
//                         'Preview',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w700,
//                           color: _textColor,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//
//                       // Khung Preview Ảnh
//                       Container(
//                         width: double.infinity,
//                         height: 450,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF2EFDE),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: const Color(0xFFC9B892),
//                             width: 1.5,
//                             style: BorderStyle.solid,
//                           ),
//                         ),
//                         child: Stack(
//                           children: [
//                             if (state.imagePath != null)
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(14),
//                                 child: Stack(
//                                   fit: StackFit.expand,
//                                   children: [
//                                     Image.file(
//                                       File(state.imagePath!),
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (_, __, ___) => Center(
//                                         child: Icon(
//                                           Icons.image,
//                                           size: 40,
//                                           color: _textColor.withOpacity(0.3),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       color: Colors.black.withOpacity(0.25),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             else
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: _cardColor,
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                               ),
//
//                             // Nút 4.8 Sao
//                             Positioned(
//                               top: 12,
//                               right: 12,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 5,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(Icons.star,
//                                         size: 14, color: Color(0xFFF5B301)),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       '4.8',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                         color: _textColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                             // Chữ Tên quán & Tính năng
//                             Positioned(
//                               bottom: 16,
//                               left: 16,
//                               right: 16,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     displayName.isEmpty
//                                         ? 'Your cafe name'
//                                         : displayName,
//                                     style: const TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     tagsLabel.isEmpty
//                                         ? (state.area.isEmpty
//                                         ? 'Area · Features'
//                                         : state.area)
//                                         : '350 m away · $tagsLabel',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white.withOpacity(0.9),
//                                     ),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 36),
//
//                       // Nút Post giờ đây sẽ luôn hiện và có thể bấm được bất kể step4Valid
//                       FlowPrimaryButton(
//                         label: 'Post',
//                         onPressed: _handlePost,
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/cafe_model.dart';
import '../../services/auth_service.dart';
import '../../services/cafe_service.dart';
import '../../states/add_cafe_state.dart';
import '../../widgets/step_flow_header.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/flow_primary_button.dart';
import '../coffee_shop_detail_screen.dart';

class Step4StoryPage extends StatefulWidget {
  const Step4StoryPage({
    super.key,
    required this.state,
    this.onPost,
  });

  final AddCafeState state;

  /// Nếu truyền vào, Claude sẽ dùng callback này thay vì tự đăng lên Firestore
  /// (hữu ích cho test/demo). Để trống thì Step4 sẽ tự upload ảnh + tạo document
  /// trong collection `cafes` khi bấm Post.
  final void Function(BuildContext context, AddCafeState state)? onPost;

  @override
  State<Step4StoryPage> createState() => _Step4StoryPageState();
}

class _Step4StoryPageState extends State<Step4StoryPage> {
  static const _maxStoryLength = 400;
  late final TextEditingController _storyController;

  final ScrollController _scrollController = ScrollController();

  static const _textColor = Color(0xFF7E654C);
  static const _backgroundColor = Color(0xFFFAF9F4);
  static const _cardColor = Color(0xFF8A6A50);

  bool _isPosting = false;

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
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSkip() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _handlePost() async {
    // Nếu người gọi trang này tự truyền onPost riêng thì ưu tiên dùng cái đó,
    // giữ nguyên hành vi cũ (backward compatible).
    if (widget.onPost != null) {
      widget.onPost!(context, widget.state);
      return;
    }
    await _uploadCafe();
  }

  Future<void> _uploadCafe() async {
    final state = widget.state;

    if (state.cafeName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter cafe name in step 2.')),
      );
      return;
    }

    final currentUser = AuthService.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to login to do this.')),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      final cafeId = await CafeService.instance.createCafe(
        cafeName: state.cafeName,
        area: state.area,
        address: state.address,
        openTime: state.openTime,
        story: state.story,
        vibes: state.vibes,
        features: state.features,
        signatureDrinks: state.signatureDrinks,
        createdBy: currentUser.uid,
        imageUrl: state.imageUrl ?? '',
      );

      if (!mounted) return;

      final newCafe = CafeModel(
        id: cafeId,
        cafeName: state.cafeName,
        story: state.story,
        openTime: state.openTime,
        createdBy: currentUser.uid,
        features: state.features.toList(),
        signatureDrinks: state.signatureDrinks
            .where((d) => d.trim().isNotEmpty)
            .toList(),
        vibes: state.vibes.toList(),
        area: state.area,
        address: state.address,
        imageUrl: state.imageUrl ?? '',
        createdAt: DateTime.now(),
      );

      // Navigate to the new cafe's detail page, clearing the add-cafe stack.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => CoffeeShopDetailScreen(cafe: newCafe)),
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post failed, please try again: $e')),
      );
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
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
        textTheme: GoogleFonts.playfairTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: RawScrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thumbColor: _textColor.withOpacity(0.5),
            radius: const Radius.circular(8),
            thickness: 5,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 26),
                      StepFlowHeader(
                        currentStep: 4,
                        totalSteps: 4,
                        onSkip: _handleSkip,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Step 4',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Story',
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w500,
                          color: _textColor,
                        ),
                      ),
                      Text(
                        'What makes your coffee shop special?',
                        style: TextStyle(
                          fontSize: 18,
                          color: _textColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Khung nhập text (Story)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2EFDE),
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
                                fontSize: 15,
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
                                fontSize: 12,
                                color: _textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      const Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Khung Preview Ảnh
                      Container(
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
                        child: Stack(
                          children: [
                            if (state.imageUrl != null && state.imageUrl!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      state.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 40,
                                          color: _textColor.withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black.withOpacity(0.25),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Container(
                                decoration: BoxDecoration(
                                  color: _cardColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),

                            // Nút 4.8 Sao
                            Positioned(
                              top: 12,
                              right: 12,
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

                            // Chữ Tên quán & Tính năng
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    displayName.isEmpty
                                        ? 'Your cafe name'
                                        : displayName,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tagsLabel.isEmpty
                                        ? (state.area.isEmpty
                                        ? 'Area · Features'
                                        : state.area)
                                        : '350 m away · $tagsLabel',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Khi đang upload: disable nút + đổi label để người dùng biết đang xử lý.
                      FlowPrimaryButton(
                        label: _isPosting ? 'Posting...' : 'Post',
                        onPressed: _isPosting ? null : _handlePost,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}