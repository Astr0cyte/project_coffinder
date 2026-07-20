import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cafe_model.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';
import 'app_colors.dart';
import 'post_page.dart';

class CoffeeShopDetailScreen extends StatefulWidget {
  const CoffeeShopDetailScreen({super.key, required this.cafe});

  final CafeModel cafe;

  @override
  State<CoffeeShopDetailScreen> createState() => _CoffeeShopDetailScreenState();
}

class _CoffeeShopDetailScreenState extends State<CoffeeShopDetailScreen> {
  static const double designWidth = 402;
  static const double designHeight = 874;

  List<ReviewModel> _reviews = [];
  late final StreamSubscription<List<ReviewModel>> _reviewsSub;

  @override
  void initState() {
    super.initState();
    _reviewsSub = ReviewService.instance
        .streamCafeReviews(widget.cafe.id)
        .listen(
          (reviews) { if (mounted) setState(() => _reviews = reviews); },
          onError: (e) => debugPrint('streamCafeReviews error: $e'),
        );
  }

  @override
  void dispose() {
    _reviewsSub.cancel();
    super.dispose();
  }

  double get _averageRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        _reviews.length;
  }

  String _starsString(int rating) =>
      '★' * rating + '☆' * (5 - rating);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = constraints.maxWidth / designWidth;
            return SizedBox(
              width: constraints.maxWidth,
              height: designHeight * scale,
              child: Stack(
                children: [
                  _heroImage(scale),
                  _heroGradient(scale),
                  _title(scale),
                  _quote(scale),
                  _locationCard(scale),
                  _backButton(context, scale),
                  _heartButton(scale),
                  _amenityChips(scale),
                  _reviewsHeader(scale),
                  _reviewsCarousel(scale),
                  _ctaButton(context, scale),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _heroImage(double s) {
    final cafe = widget.cafe;
    return Positioned(
      left: -4 * s,
      top: -50 * s,
      width: 407 * s,
      height: 450 * s,
      child: cafe.imageUrl.isNotEmpty
          ? Image.network(
              cafe.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => Container(color: AppColors.brownMid),
            )
          : Container(color: AppColors.brownMid),
    );
  }

  Widget _heroGradient(double s) {
    return Positioned(
      left: -40 * s,
      top: -3 * s,
      width: 452 * s,
      height: 133 * s,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD9D9D9), Color(0x00737373)],
          ),
        ),
      ),
    );
  }

  Widget _title(double s) {
    return Positioned(
      left: 15 * s,
      top: 302 * s,
      width: 250 * s,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18 * s, vertical: 12 * s),
        decoration: BoxDecoration(
          color: AppColors.brownMid.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20 * s),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8 * s,
              offset: Offset(0, 3 * s),
            ),
          ],
        ),
        child: Text(
          widget.cafe.cafeName,
          style: GoogleFonts.playfairDisplay(
            fontSize: 26 * s,
            fontWeight: FontWeight.w600,
            color: AppColors.gold,
          ),
        ),
      ),
    );
  }

  Widget _quote(double s) {
    final text = widget.cafe.story.isNotEmpty
        ? '"${widget.cafe.story}"'
        : '"Where every cup tells a story"';
    return Positioned(
      left: 21 * s,
      top: 414 * s,
      width: 280 * s,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.playfairDisplay(
          fontSize: 18 * s,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: AppColors.brownDark,
        ),
      ),
    );
  }

  Widget _locationCard(double s) {
    final cafe = widget.cafe;
    return Positioned(
      left: 16 * s,
      top: 342 * s,
      width: 370 * s,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18 * s, vertical: 12 * s),
        decoration: BoxDecoration(
          color: AppColors.brownMid.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20 * s),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8 * s,
              offset: Offset(0, 3 * s),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              cafe.address.isNotEmpty ? cafe.address : cafe.area,
              style: GoogleFonts.inter(
                fontSize: 14 * s,
                fontWeight: FontWeight.w400,
                color: AppColors.gold,
              ),
            ),
            if (cafe.openTime.isNotEmpty) ...[
              SizedBox(height: 6 * s),
              Text(
                'Open: ${cafe.openTime}',
                style: GoogleFonts.inter(
                  fontSize: 12 * s,
                  fontWeight: FontWeight.w400,
                  color: AppColors.gold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _circleButton(double s, double left, IconData icon, VoidCallback onTap) {
    return Positioned(
      left: left * s,
      top: 27 * s,
      width: 36 * s,
      height: 36 * s,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.55),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 6 * s,
                offset: Offset(0, 2 * s),
              ),
            ],
          ),
          child: Icon(icon, size: 16 * s, color: AppColors.brownDark),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context, double s) =>
      _circleButton(s, 20, Icons.arrow_back, () => Navigator.maybePop(context));

  Widget _heartButton(double s) =>
      _circleButton(s, 349, Icons.favorite_border, () {});

  Widget _amenityChips(double s) {
    return Positioned(
      left: 16 * s,
      top: 474 * s,
      width: 370 * s,
      child: Wrap(
        spacing: 8 * s,
        runSpacing: 8 * s,
        children: widget.cafe.features.map((label) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 6 * s),
            decoration: BoxDecoration(
              color: AppColors.brownDark,
              borderRadius: BorderRadius.circular(40 * s),
              border: Border.all(color: AppColors.brownMid, width: 0.5),
            ),
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 10 * s, color: AppColors.tan),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _reviewsHeader(double s) {
    final count = _reviews.length;
    final avg = _averageRating;
    final subtitle = count == 0
        ? 'No reviews yet'
        : '${avg.toStringAsFixed(1)}  ·  $count ${count == 1 ? 'review' : 'reviews'}';

    return Positioned(
      left: 20 * s,
      top: 556 * s,
      width: 300 * s,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18 * s,
              fontWeight: FontWeight.w600,
              color: AppColors.brownDark,
            ),
          ),
          SizedBox(height: 6 * s),
          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 13 * s, color: AppColors.brownMid),
          ),
        ],
      ),
    );
  }

  Widget _reviewsCarousel(double s) {
    if (_reviews.isEmpty) {
      return Positioned(
        left: 20 * s,
        top: 604 * s,
        width: 362 * s,
        child: Text(
          'Be the first to leave a review!',
          style: GoogleFonts.inter(
            fontSize: 13 * s,
            fontStyle: FontStyle.italic,
            color: AppColors.brownMid,
          ),
        ),
      );
    }

    return Positioned(
      left: 0,
      top: 604 * s,
      width: 402 * s,
      height: 156 * s,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20 * s, vertical: 8 * s),
        itemCount: _reviews.length,
        separatorBuilder: (_, __) => SizedBox(width: 16 * s),
        itemBuilder: (context, i) => _reviewCard(s, _reviews[i]),
      ),
    );
  }

  Widget _reviewCard(double s, ReviewModel r) {
    return Container(
      width: 260 * s,
      height: 140 * s,
      padding: EdgeInsets.all(14 * s),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16 * s),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8 * s,
            offset: Offset(0, 3 * s),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36 * s,
                height: 36 * s,
                decoration:
                    const BoxDecoration(color: AppColors.tan, shape: BoxShape.circle),
              ),
              SizedBox(width: 10 * s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13 * s,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brownDark,
                      ),
                    ),
                    Text(
                      _starsString(r.rating),
                      style: GoogleFonts.inter(
                          fontSize: 12 * s, color: AppColors.brownMid),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10 * s),
          Expanded(
            child: Text(
              r.comment,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style:
                  GoogleFonts.inter(fontSize: 12 * s, color: AppColors.brownMid),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ctaButton(BuildContext context, double s) {
    return Positioned(
      left: 37 * s,
      top: 770 * s,
      width: 320 * s,
      height: 60 * s,
      child: GestureDetector(
        onTap: () {
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
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.brownMid,
            borderRadius: BorderRadius.circular(20 * s),
            border: Border.all(color: AppColors.brownDark, width: 0.5),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 4)),
            ],
          ),
          child: Text(
            'Post Your Visit',
            style: GoogleFonts.inter(
              fontSize: 14 * s,
              fontWeight: FontWeight.w600,
              color: AppColors.tan,
            ),
          ),
        ),
      ),
    );
  }
}
