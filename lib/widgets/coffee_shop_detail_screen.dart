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

    final GlobalKey<PopupMenuButtonState<String>> _popupKey = GlobalKey();

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
              return _buildDetailSheet(scrollController);
            },
          )
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

  Widget _buildDetailSheet(ScrollController scrollController){
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xFFFAF9F4),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          )
      ),

      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          //  1. Coffee Shop Name  --> Database
          Text(
            widget.shopName,
            style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Color(0xFF402F11)
            ),
          ),
          const SizedBox(height: 8),
          //  2. Address + Phone --> Database
          Text(widget.address, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 16),
          const SizedBox(height: 16),

          // 3. Amenity Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.amenities.map((tag) => _buildAmenityTagItem(tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityTagItem(AmenityTag tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tag.isActive ? const Color(0xFFE6D7C3) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag.label,
        style: TextStyle(color: tag.isActive ? const Color(0xFF402F11) : Colors.grey.shade500),
      ),
    );
  }
}


