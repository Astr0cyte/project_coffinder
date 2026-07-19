import 'package:brewstreet_app/pages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ReviewData {
  final String name;
  final String stars;
  final String text;
  const ReviewData(this.name, this.stars, this.text);
}

class AmenityChip {
  final String label;
  final bool active;
  const AmenityChip(this.label, this.active);
}

class CoffeeShopDetailScreen extends StatelessWidget {
  const CoffeeShopDetailScreen({
  super.key,
  required this.cafeId,
  required this.shopName,
});

  final String cafeId;
  final String shopName;


  static const double designWidth = 402;
  static const double designHeight = 874;

Future<DocumentSnapshot<Map<String, dynamic>>> getCafe() {
  return FirebaseFirestore.instance
      .collection("cafes")
      .doc(cafeId)
      .get();
}

  

  @override
Widget build(BuildContext context) {
  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    future: getCafe(),
    builder: (context, snapshot) {

      if (!snapshot.hasData) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final cafe = snapshot.data!.data()!;

      return _buildPage(
        context,
        cafe,
      );
    },
  );
}

  // --- Hero photo -----------------------------------------------------
  Widget _heroImage(double s) {
    return Positioned(
      left: -4 * s,
      top: -50 * s,
      width: 407 * s,
      height: 450 * s,
      child: Container(color: AppColors.brownMid),
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

  // --- Header text ------------------------------------------------------
  Widget _title(double s, Map<String, dynamic> cafe) {
    return Positioned(
      left: 15 * s,
      top: 260 * s,
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
          cafe["cafe_name"] ?? "",
          style: GoogleFonts.playfairDisplay(
            fontSize: 26 * s,
            fontWeight: FontWeight.w600,
            color: AppColors.gold,
          ),
        ),
      ),
    );
  }

  Widget _quote(double s, Map<String, dynamic> cafe) {
    return Positioned(
      left: 21 * s,
      top: 414 * s,
      width: 280 * s,
      child: Text(
        cafe["description"] ?? "",
        style: GoogleFonts.playfairDisplay(
          fontSize: 18 * s,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: AppColors.brownDark,
        ),
      ),
    );
  }

  // --- Address / phone overlay ------------------------------------------
  Widget _locationCard(double s, Map<String, dynamic> cafe) {
    return Positioned(
      left: 16 * s,
      top: 320 * s,
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
              cafe["address"] ?? "",
              style: GoogleFonts.inter(
                fontSize: 14 * s,
                fontWeight: FontWeight.w400,
                color: AppColors.gold,
              ),
            ),
            SizedBox(height: 6 * s),
            Text(
              'Phone number: ${cafe["phone"] ?? ""}',
              style: GoogleFonts.inter(
                fontSize: 12 * s,
                fontWeight: FontWeight.w400,
                color: AppColors.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Top buttons --------------------------------------------------------
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

  Widget _backButton(BuildContext context, double s) {
    return _circleButton(s, 20, Icons.arrow_back, () => Navigator.maybePop(context));
  }

  Widget _heartButton(double s) {
    return _circleButton(s, 349, Icons.favorite_border, () {});
  }

  // --- Amenity chips ------------------------------------------------------
  Widget _amenityChips(double s, Map<String, dynamic> cafe) {

  final tags = List<String>.from(cafe["tags"] ?? []);

  return Positioned(
    left: 16 * s,
    top: 474 * s,
    width: 370 * s,
    child: Wrap(
      spacing: 8 * s,
      runSpacing: 8 * s,
      children: tags.map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14 * s,
            vertical: 6 * s,
          ),
          decoration: BoxDecoration(
            color: AppColors.brownDark,
            borderRadius: BorderRadius.circular(40 * s),
          ),
          child: Text(
            tag,
            style: GoogleFonts.inter(
              fontSize: 10 * s,
              color: AppColors.tan,
            ),
          ),
        );
      }).toList(),
    ),
  );
}

  // --- Reviews -------------------------------------------------------------
  Widget _reviewsHeader(double s, Map<String, dynamic> cafe) {
    return Positioned(
      left: 20 * s,
      top: 556 * s,
      width: 300 * s,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6 * s),
          Text(
            "${cafe["average_rating"]} · ${cafe["review_count"]} reviews",
            style: GoogleFonts.inter(fontSize: 13 * s, color: AppColors.brownMid),
          ),
        ],
      ),
    );
  }

  Widget _reviewsCarousel(double s) {
  return Positioned(
    left: 0,
    top: 604 * s,
    width: 402 * s,
    height: 156 * s,
    child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('cafe_id', isEqualTo: cafeId)
          .snapshots(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final reviews = snapshot.data!.docs;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: reviews.length,
          itemBuilder: (context, index) {

            final review =
                reviews[index].data() as Map<String, dynamic>;

            return _reviewCard(
              s,
              ReviewData(
                review['user_name'] ?? '',
                "${review['rating']} ★",
                review['comment'] ?? '',
              ),
            );
          },
        );
      },
    ),
  );
}

  Widget _reviewCard(double s, ReviewData r) {
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
                decoration: const BoxDecoration(color: AppColors.tan, shape: BoxShape.circle),
              ),
              SizedBox(width: 10 * s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.name,
                      style: GoogleFonts.inter(
                        fontSize: 13 * s,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brownDark,
                      ),
                    ),
                    Text(
                      r.stars,
                      style: GoogleFonts.inter(fontSize: 12 * s, color: AppColors.brownMid),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10 * s),
          Expanded(
            child: Text(
              r.text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 12 * s, color: AppColors.brownMid),
            ),
          ),
        ],
      ),
    );
  }

  // --- Sticky CTA ------------------------------------------------------------
  Widget _ctaButton(BuildContext context, double s) {
    return Positioned(
      left: 37 * s,
      top: 770 * s,
      width: 320 * s,
      height: 60 * s,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post your visit tapped')),
          );
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.brownMid,
            borderRadius: BorderRadius.circular(20 * s),
            border: Border.all(color: AppColors.brownDark, width: 0.5),
            boxShadow: const [
              BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 4)),
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
  Widget _buildPage(
  BuildContext context,
  Map<String, dynamic> cafe,
) {
  return Scaffold(
    backgroundColor: AppColors.cream,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {

          final scale = constraints.maxWidth / designWidth;

          return Stack(
            children: [

              _heroImage(scale),

              _heroGradient(scale),

              _title(scale, cafe),

              _quote(scale, cafe),

              _locationCard(scale, cafe),

              _backButton(context, scale),

              _heartButton(scale),

              _amenityChips(scale, cafe),

              _reviewsHeader(scale, cafe),

              _reviewsCarousel(scale),

              _ctaButton(context, scale),
            ],
          );
        },
      ),
    ),
  );
}
}