import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cafe_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../services/review_service.dart';
import '../services/saved_cafe_service.dart';
import '../services/user_service.dart';
import 'app_colors.dart';
import 'post_page.dart';

class CoffeeShopDetailScreen extends StatefulWidget {
  const CoffeeShopDetailScreen({super.key, required this.cafe});

  final CafeModel cafe;

  @override
  State<CoffeeShopDetailScreen> createState() => _CoffeeShopDetailScreenState();
}

class _CoffeeShopDetailScreenState extends State<CoffeeShopDetailScreen> {
  bool _isFavorite = false;
  bool _savingInProgress = false;
  bool _isPinned = false;
  bool _pinningInProgress = false;
  String? _sortOrder;

  List<ReviewModel> _reviews = [];
  late final StreamSubscription<List<ReviewModel>> _reviewsSub;
  StreamSubscription<bool>? _savedSub;
  StreamSubscription<UserModel>? _userSub;
  final GlobalKey<PopupMenuButtonState<String>> _popupKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _reviewsSub = ReviewService.instance
        .streamCafeReviews(widget.cafe.id)
        .listen(
          (reviews) { if (mounted) setState(() => _reviews = reviews); },
          onError: (e) => debugPrint('streamCafeReviews error: $e'),
        );

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.isAnonymous) {
      _savedSub = SavedCafeService.instance
          .streamIsSaved(user.uid, widget.cafe.id)
          .listen(
            (saved) { if (mounted) setState(() => _isFavorite = saved); },
            onError: (e) => debugPrint('streamIsSaved error: $e'),
          );
      _userSub = UserService.instance.streamUser(user.uid).listen(
        (u) {
          if (mounted) setState(() => _isPinned = u.pinnedCafeId == widget.cafe.id);
        },
        onError: (e) => debugPrint('streamUser error: $e'),
      );
    }
  }

  @override
  void dispose() {
    _reviewsSub.cancel();
    _savedSub?.cancel();
    _userSub?.cancel();
    super.dispose();
  }

  Future<void> _toggleSaved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to save coffee shops.')),
      );
      return;
    }
    if (_savingInProgress) return;
    setState(() => _savingInProgress = true);
    try {
      await SavedCafeService.instance.toggle(user.uid, widget.cafe.id);
    } catch (e) {
      debugPrint('toggleSaved error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update saved shops. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _savingInProgress = false);
    }
  }

  Future<void> _togglePin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) return;
    if (_pinningInProgress) return;
    setState(() => _pinningInProgress = true);
    try {
      if (_isPinned) {
        await UserService.instance.unpinCafe(user.uid);
      } else {
        await UserService.instance.pinCafe(user.uid, widget.cafe.id);
      }
    } catch (e) {
      debugPrint('togglePin error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update pinned shop. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _pinningInProgress = false);
    }
  }

  double get _averageRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) / _reviews.length;
  }

  List<ReviewModel> get _sortedReviews {
    final list = List<ReviewModel>.from(_reviews);
    if (_sortOrder == 'high_to_low') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortOrder == 'low_to_high') {
      list.sort((a, b) => a.rating.compareTo(b.rating));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          _shopImage(screenHeight),
          _backButton(),
          _heartButton(),
          if (_isFavorite) _pinButton(),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.70,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Shop name
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          widget.cafe.cafeName,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brownDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Address + open time
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.quicksand(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: AppColors.brownDark,
                            ),
                            children: [
                              TextSpan(
                                text: widget.cafe.address.isNotEmpty
                                    ? widget.cafe.address
                                    : widget.cafe.area,
                              ),
                              if (widget.cafe.openTime.isNotEmpty)
                                TextSpan(
                                  text: '\nOpen: ${widget.cafe.openTime}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Story / description
                      if (widget.cafe.story.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.75,
                            child: Text(
                              '"${widget.cafe.story}"',
                              style: GoogleFonts.quicksand(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                                color: AppColors.brownDark,
                              ),
                            ),
                          ),
                        ),

                      // Amenity chips
                      if (widget.cafe.features.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.cafe.features.map((label) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.brownDark,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: AppColors.brownMid, width: 1),
                                ),
                                child: Text(
                                  label,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.tan,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      // Reviews header + filter button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reviews',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.brownDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _reviews.isEmpty
                                      ? 'No reviews yet'
                                      : '${_averageRating.toStringAsFixed(1)} · ${_reviews.length} ${_reviews.length == 1 ? 'review' : 'reviews'}',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: AppColors.brownMid,
                                  ),
                                ),
                              ],
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                splashFactory: NoSplash.splashFactory,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              ),
                              child: PopupMenuButton<String>(
                                key: _popupKey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: AppColors.chipLight,
                                offset: const Offset(0, 45),
                                onSelected: (value) => setState(() => _sortOrder = value),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    splashColor: Colors.white.withValues(alpha: 0.3),
                                    highlightColor: Colors.white.withValues(alpha: 0.2),
                                    onTap: () => _popupKey.currentState?.showButtonMenu(),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: AppColors.chipLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const RotatedBox(
                                        quarterTurns: 1,
                                        child: Icon(Icons.tune, size: 20, color: AppColors.brownDark),
                                      ),
                                    ),
                                  ),
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem<String>(
                                    value: 'high_to_low',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.arrow_downward, size: 18, color: AppColors.brownDark),
                                        const SizedBox(width: 8),
                                        Text(
                                          'High to Low',
                                          style: GoogleFonts.quicksand(
                                            color: AppColors.brownDark,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    enabled: false,
                                    height: 1,
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                      height: 1,
                                      color: AppColors.brownDark.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'low_to_high',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.arrow_upward, size: 18, color: AppColors.brownDark),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Low to High',
                                          style: GoogleFonts.quicksand(
                                            color: AppColors.brownDark,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Reviews carousel
                      if (_reviews.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Text(
                            'Be the first to leave a review!',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: AppColors.brownMid,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 160,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _sortedReviews.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (_, i) => _reviewCard(screenWidth, _sortedReviews[i]),
                          ),
                        ),

                      const SizedBox(height: 11),

                      // Post Your Visit CTA
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brownMid,
                              foregroundColor: Colors.white.withValues(alpha: 0.05),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: const BorderSide(width: 0.5, color: AppColors.brownDark),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PostPage(
                                    placeName: widget.cafe.cafeName,
                                    placeAddress: widget.cafe.address,
                                    cafeId: widget.cafe.id,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Post Your Visit',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.tan,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _shopImage(double screenHeight) {
    final url = widget.cafe.imageUrl;
    final h = screenHeight * 0.45;
    return url.isNotEmpty
        ? Image.network(
            url,
            width: double.infinity,
            height: h,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(height: h, color: AppColors.brownMid),
          )
        : Container(height: h, color: AppColors.brownMid);
  }

  Widget _backButton() {
    return Positioned(
      top: 40,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cream.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brownDark, size: 28),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }

  Widget _heartButton() {
    return Positioned(
      top: 40,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cream.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: _savingInProgress
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.brownDark,
                  ),
                )
              : Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.brownDark,
                ),
          onPressed: _toggleSaved,
        ),
      ),
    );
  }

  Widget _pinButton() {
    return Positioned(
      top: 100,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cream.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          tooltip: _isPinned ? 'Unpin from profile' : 'Pin to profile',
          icon: _pinningInProgress
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.brownDark,
                  ),
                )
              : Icon(
                  _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: AppColors.brownDark,
                ),
          onPressed: _togglePin,
        ),
      ),
    );
  }

  Widget _reviewCard(double screenWidth, ReviewModel r) {
    return Container(
      width: screenWidth * 0.65,
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 18, backgroundColor: AppColors.tan),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brownDark,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < r.rating ? Icons.star : Icons.star_border,
                          size: 14,
                          color: AppColors.brownMid,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            r.comment,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.brownMid,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
