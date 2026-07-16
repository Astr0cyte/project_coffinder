import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Review {
  final String name;
  final int stars;
  final String comment;
  final String? avatarUrl;
  const Review({required this.name, required this.stars, required this.comment, this.avatarUrl});
}

class AmenityTag {
  final String label;
  final double percentage;

  const AmenityTag({required this.label, required this.percentage});

  // TODO: Percentage is called from Database.
  bool get isActive => percentage >= 0.5;
}

class CoffeeShopDetailScreen extends StatefulWidget{
  final String shopName;
  final String address;
  final String phone;
  final String imageUrl;
  final String description;
  final List<AmenityTag> amenities;     // Create a Class
  final List<Review> reviews;           //Create a Class
  final double rating;
  final int reviewCount;


  static const double designWidth = 402;
  static const double designHeight = 874;

  static const reviews = [
    ReviewData('Mike', '★★★★★',
        'Great atmosphere and the coffee is amazing. Perfect place to work or relax.'),
    ReviewData('Anna', '★★★★☆',
        'Great wifi and quiet enough to work from. Will come back.'),
    ReviewData('4Q', '★★★★★',
        'Friendly staff and a beautiful space. Loved the ambience.'),
  ];


  @override
  State<CoffeeShopDetailScreen> createState() => _CoffeeShopDetailScreenState();
}

class _CoffeeShopDetailScreenState extends State<CoffeeShopDetailScreen> {
  bool isFavorite = false;
  String? sortOrder;

  // Click "Post your Visit" -> Submit -> Amenity Tag + countReview -> Change
  // Now: Static Screen - Mon 13/7/26
  late double currentRating;
  late int currentReviewCount;
  late List<Review> currentReviews;

  @override
  void initState() {
    super.initState();
    currentRating = widget.rating;
    currentReviewCount = widget.reviewCount;
    currentReviews = widget.reviews;
  }

  @override
  Widget build(BuildContext context) {
    // Fix --> screen ratio
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final GlobalKey<PopupMenuButtonState<String>> _popupKey = GlobalKey();
    final List<String> requiredLabels = [
      'Air conditioned',
      'Pets',
      'Quiet',
      'Wi-Fi',
      'Friendly'
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F4),
      body: Stack(
        children: [
          _shopImage(screenHeight),
          _returnHomePage(),
          _heartButton(),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                    color: Color(0xFFFAF9F4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    )
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const SizedBox(height: 20.0),
                      // 1. TODO: Coffee shop Name --> Database
                      Padding(
                        padding: const EdgeInsets.only(left: 16.5),
                        child: Text(
                          widget.shopName,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF402F11),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6.0),

                      // 2. Address + Phone --> Database
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.quicksand(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF402F11),
                            ),
                            children: [
                              TextSpan(text: '${widget.address}\n'),
                              TextSpan(
                                text: 'Phone number: ${widget.phone}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 3. Description --> Database
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.7, // 55% width
                          child: Text(
                            widget.description,
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF402F11),
                            ),
                          ),
                        ),
                      ),

                      // 4. Amenities / Tags Rating --> Database
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: widget.amenities.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: tag.isActive
                                    ? const Color(0xFF402F11)
                                    : const Color(0xFFEFECDC),
                                borderRadius: BorderRadius.circular(999.0),
                                border: Border.all(
                                  color: tag.isActive
                                      ? const Color(0xFF7E654C)
                                      : const Color(0xFFDED4BA),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                tag.label,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: tag.isActive
                                      ? const Color(0xFFDED4BA)
                                      : const Color(0xFF7E654C),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // 5. Reviews header + Button icon (Filter) + Amount Review + Star Rating
                      // TODO: Filter + Amount Reviews + Star Rating --> Database
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                                    color: const Color(0xFF402F11),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  '${widget.rating} · ${widget
                                      .reviewCount} reviews',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: const Color(0xFF7E654C),
                                  ),
                                ),
                              ],
                            ),

                            //  Filter Button
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
                                color: const Color(0xFFEFECDC),
                                offset: const Offset(0, 45),

                                onSelected: (String value) {
                                  // TODO: Star Rating
                                  if (value == 'high_to_low') {
                                    print('Sort: Rating High to Low'); // Debug

                                  } else if (value == 'low_to_high') {
                                    print('Sort: Rating Low to High'); // Debug
                                  }
                                },

                                //
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    splashColor: Colors.white.withValues(
                                        alpha: 0.3),
                                    highlightColor: Colors.white.withValues(
                                        alpha: 0.2),

                                    onTap: () {
                                      _popupKey.currentState?.showButtonMenu();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEFECDC),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const RotatedBox(
                                        quarterTurns: 1,
                                        child: Icon(
                                          Icons.tune,
                                          size: 20,
                                          color: Color(0xFF402F11),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                itemBuilder: (BuildContext context) =>
                                [
                                  PopupMenuItem<String>(
                                    value: 'high_to_low',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.arrow_downward, size: 18,
                                            color: Color(0xFF402F11)),
                                        const SizedBox(width: 8),
                                        Text(
                                          'High to Low',
                                          style: GoogleFonts.quicksand(
                                              color: const Color(0xFF402F11),
                                              fontWeight: FontWeight.w600,
                                          )
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
                                      color: const Color(0xFF402F11).withValues(
                                          alpha: 0.2),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'low_to_high',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.arrow_upward, size: 18,
                                            color: Color(0xFF402F11)),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Low to High',
                                          style: GoogleFonts.quicksand(
                                              color: Color(0xFF402F11),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      // 6. Review card + Text box Animation: left/right
                      // TODO: Username + Rating + Photo Username --> Database
                      SizedBox(
                        height: 160, //
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          children: [
                            // Card 1 - Mike
                            Container(
                              width: screenWidth * 0.65,
                              margin: const EdgeInsets.only(right: 12.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color:  Color(0xFFF5F1DC),
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: Color(0xFFDED4BA),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.brown[200],
                                        // TODO: backgroundImage: AssetImage('assets/images/mike.png'),
                                        // IMGAGE FROM DATABASE
                                      ),
                                      SizedBox(width: 8.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            'Mike',
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF402F11),
                                            ),
                                          ),
                                          Row(
                                            // TODO: Stars Rating of a User --> Database
                                            children: List.generate(
                                              5,
                                                  (index) =>
                                                  Icon(Icons.star, size: 14,
                                                      color: Color(0xFF7E654C)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.0),

                                  SizedBox(height: 8.0),
                                  Text(
                                    'Great atmosphere and the coffee is amazing. Perfect place to work or relax.',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Color(0xFF7E654C),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Card 2 - ????
                            Container(
                              width: screenWidth * 0.65,
                              margin: const EdgeInsets.only(right: 12.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F1DC),
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: Color(0xFFDED4BA),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.brown[200],
                                        // TODO: backgroundImage: AssetImage('assets/images/mike.png'),
                                        // IMGAGE FROM DATABASE
                                      ),
                                      SizedBox(width: 8.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            '????',
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF402F11),
                                            ),
                                          ),
                                          Row(
                                            // TODO: Stars Rating of a User --> Database
                                            children: List.generate(
                                              5,
                                                  (index) =>
                                                  Icon(Icons.star, size: 14,
                                                      color: Color(0xFF7E654C)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.0),

                                  SizedBox(height: 8.0),
                                  Text(
                                    'Great atmosphere and the coffee is amazing. Perfect place to work or relax.',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Color(0xFF7E654C),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Card 3
                            Container(
                              width: screenWidth * 0.65,
                              margin: const EdgeInsets.only(right: 12.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F1DC),
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: Color(0xFFDED4BA),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.brown[200],
                                        // TODO: backgroundImage: AssetImage('assets/images/mike.png'),
                                        // IMGAGE FROM DATABASE
                                      ),
                                      SizedBox(width: 8.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            '????_2',
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF402F11),
                                            ),
                                          ),
                                          Row(
                                            // TODO: Stars Rating of a User --> Database
                                            children: List.generate(
                                              5,
                                                  (index) =>
                                                  Icon(Icons.star, size: 14,
                                                      color: Color(0xFF7E654C)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.0),

                                  SizedBox(height: 8.0),
                                  Text(
                                    'Great atmosphere and the coffee is amazing. Perfect place to work or relax.',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Color(0xFF7E654C),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(height: 11.0),
                      // 7. Post your vist
                      // TODO: Push --> Post Review page
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF7E654C),
                              foregroundColor: Colors.white.withValues(
                                  alpha: 0.05),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              side: const BorderSide(
                                width: 0.5,
                                color: Color(0xFF402F11),
                              ),
                            ),
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } // Crash
                              // TODO: Navigator.push --> Post Review Page
                            },
                            child: Text(
                              'Post Your Visit',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFDED4BA),
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

  // -- Coffee Shop Image --> Database
  Widget _shopImage(double height) {
    return Image.asset(
      widget.imageUrl, // Image.network if imageUrl: link online
      width: double.infinity,
      height: height * 0.5,
      fit: BoxFit.cover,
    );
  }

  // -- Return Home_Page Button
  // TODO: Return Home_Page
  Widget _returnHomePage() {
    return Positioned(
      top: 40,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAF9F4).withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color(0xFF402F11), size: 28),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } // Crash
            // TODO: return --> Home Page
          },
        ),
      ),
    );
  }

  // Add/Remove Favorite List --> Database in Future Development
  Widget _heartButton() {
    return Positioned(
      top: 40,
      right: 16,
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
  Widget _title(double s) {
    return Positioned(
      left: 15 * s,
      top: 260 * s,
      width: 250 * s,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18 * s, vertical: 12 * s),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF9F4).withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Text(
          shopName,
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
    return Positioned(
      left: 21 * s,
      top: 414 * s,
      width: 280 * s,
      child: Text(
        '“Where every cup tells a story”',
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
  Widget _locationCard(double s) {
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
              '123 Nguyen Hue Street, District 1, HCMC',
              style: GoogleFonts.inter(
                fontSize: 14 * s,
                fontWeight: FontWeight.w400,
                color: AppColors.gold,
              ),
            ),
            SizedBox(height: 6 * s),
            Text(
              'Phone number: 686868686',
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
  Widget _amenityChips(double s) {
    return Positioned(
      left: 16 * s,
      top: 474 * s,
      width: 370 * s,
      child: Wrap(
        spacing: 8 * s,
        runSpacing: 8 * s,
        children: amenities.map((a) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 6 * s),
            decoration: BoxDecoration(
              color: a.active ? AppColors.brownDark : AppColors.chipLight,
              borderRadius: BorderRadius.circular(40 * s),
              border: Border.all(
                color: a.active ? AppColors.brownMid : AppColors.cardBorder,
                width: 0.5,
              ),
            ),
            child: Text(
              a.label,
              style: GoogleFonts.inter(
                fontSize: 10 * s,
                color: a.active ? AppColors.tan : AppColors.brownMid,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Reviews -------------------------------------------------------------
  Widget _reviewsHeader(double s) {
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
            '4.8  ·  128 reviews',
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
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20 * s, vertical: 8 * s),
        itemCount: reviews.length,
        separatorBuilder: (_, __) => SizedBox(width: 16 * s),
        itemBuilder: (context, i) => _reviewCard(s, reviews[i]),
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
}