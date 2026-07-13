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

  const CoffeeShopDetailScreen({
    super.key,
    required this.shopName,
    required this.address,
    required this.phone,
    required this.imageUrl,
    required this.description,
    required this.amenities,
    required this.reviews,
    required this.rating,
    required this.reviewCount,
  });


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
  Widget build(BuildContext context){

    // Fix --> screen ratio
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final GlobalKey<PopupMenuButtonState<String>> _popupKey = GlobalKey();final List<String> requiredLabels = ['Air conditioned', 'Pets', 'Quiet', 'Wi-Fi', 'Friendly'];


    List<AmenityTag> displayAmenities = requiredLabels.map((label) {
      // Tìm xem trong widget.amenities truyền vào có tag này không
      final matchingTag = widget.amenities.firstWhere(
            (element) => element.label.toLowerCase() == label.toLowerCase(),
        orElse: () => AmenityTag(label: label, percentage: 0.0), // Nếu không truyền thì mặc định percentage = 0.0 (Tắt)
      );
      return matchingTag;
    }).toList();

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
            maxChildSize: 0.6,
            builder: (context, scrollController){
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

                      // 1. TODO: Coffee shop Name --> Database
                      Padding(
                        padding: const EdgeInsets.only(left: 23.0),
                        child: Text(
                          widget.shopName,
                          style: const TextStyle(
                            fontFamily: 'Playfair_Display',
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF402F11),
                          ),
                        ),
                      ),

                      SizedBox(height: 0.0),

                      // 2. TODO: Address + Phone --> Database
                      Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Color(0xFF7E654C),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          '${widget.address}\nPhone number: ${widget.phone}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Quick-sand',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFDED4BA),
                          ),
                        ),

                      ),

                      // 3. TODO: Description --> Database
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.7, // 55% width
                          child: Text(
                            widget.description,
                            style: const TextStyle(
                              fontFamily: 'Rale-wayItalic',
                              fontSize: 20,
                              color: Color(0xFF402F11),
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),

                      // 4. TODO: Amenities / Tags Rating --> Database
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF402F11),
                                borderRadius: BorderRadius.circular(999.0),
                                border: Border.all(
                                  color: Color(0xFF7E654C),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                'Air conditioned',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFDED4BA),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFEFECDC),
                                borderRadius: BorderRadius.circular(999.0),
                                border: Border.all(
                                  color: Color(0xFFDED4BA),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                'Pets',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF7E654C),
                                  fontFamily:  '',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF402F11),
                                borderRadius: BorderRadius.circular(999.0),
                                border: Border.all(
                                  color: Color(0xFF7E654C),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                'Quiet',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFDED4BA),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFEFECDC),
                                borderRadius: BorderRadius.circular(999.0),
                                border: Border.all(
                                  color: Color(0xFFDED4BA),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                'Wi-Fi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF7E654C),
                                  fontFamily:  'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFEFECDC),
                                borderRadius: BorderRadius.circular(999.0),
                                border: Border.all(
                                  color: Color(0xFFDED4BA),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                'Friendly',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF7E654C),
                                  fontFamily:  'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
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
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Playfair_Display',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF402F11),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  '${widget.rating} · ${widget.reviewCount} reviews',
                                  style: TextStyle(
                                    fontFamily: 'Inter' ,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Color(0xFF7E654C),
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
                                    splashColor: Colors.white.withValues(alpha: 0.3),
                                    highlightColor: Colors.white.withValues(alpha: 0.2),

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

                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem<String>(
                                    value: 'high_to_low',
                                    child: Row(
                                      children: [
                                        Icon(Icons.arrow_downward, size: 18, color: Color(0xFF402F11)),
                                        SizedBox(width: 8),
                                        Text(
                                          'High to Low',
                                          style: TextStyle(color: Color(0xFF402F11), fontWeight: FontWeight.w600, fontFamily: 'Quick-sand'),
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
                                      color: const Color(0xFF402F11).withValues(alpha: 0.2),
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'low_to_high',
                                    child: Row(
                                      children: [
                                        Icon(Icons.arrow_upward, size: 18, color: Color(0xFF402F11)),
                                        SizedBox(width: 8),
                                        Text(
                                          'Low to High',
                                          style: TextStyle(fontFamily: 'Quick-sand' ,color: Color(0xFF402F11), fontWeight: FontWeight.w600),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children :[
                                          Text(
                                            'Mike',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF402F11),
                                            ),
                                          ),
                                          Row(
                                            // TODO: Stars Rating of a User --> Database
                                            children: List.generate(
                                              5,
                                                  (index) => Icon(Icons.star, size: 14, color: Color(0xFF7E654C)),
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
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF7E654C),
                                      fontFamily: 'Inter',
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children :[
                                          Text(
                                            '????',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF402F11),
                                            ),
                                          ),
                                          Row(
                                            // TODO: Stars Rating of a User --> Database
                                            children: List.generate(
                                              5,
                                                  (index) => Icon(Icons.star, size: 14, color: Color(0xFF7E654C)),
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
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF7E654C),
                                      fontFamily: 'Inter',
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children :[
                                          Text(
                                            '???_2',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF402F11),
                                            ),
                                          ),
                                          Row(
                                            // TODO: Stars Rating of a User --> Database
                                            children: List.generate(
                                              5,
                                                  (index) => Icon(Icons.star, size: 14, color: Color(0xFF7E654C)),
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
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF7E654C),
                                      fontFamily: 'Inter',
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

                      // 7. Post your vist
                      // TODO: Push --> Post Review page
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF7E654C),
                              foregroundColor: Colors.white.withValues(alpha: 0.05),
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Quick-sand',
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
  Widget _shopImage(double height){
    return Image.asset(
      widget.imageUrl,  // Image.network if imageUrl: link online
      width: double.infinity,
      height: height * 0.5,
      fit: BoxFit.cover,
    );
  }

  // -- Return Home_Page Button
  // TODO: Return Home_Page
  Widget _returnHomePage(){
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
  Widget _heartButton(){
    return Positioned(
      top: 40,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAF9F4).withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite
                  ? const Color(0xFFDB8D1F)
                  : const Color(0xFF402F11)),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
            // TODO: Save --> Favorite or Remove Favorite List
          },
        ),
      ),
    );
  }

}




