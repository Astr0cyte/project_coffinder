import 'package:flutter/material.dart';
import 'coffee_shop_detail_screen.dart';

void main() {
  runApp(MaterialApp(
    home: CoffeeShopDetailScreen(
      shopName: 'Phuc Long',
      address: '123 Nguyen Hue, District 1, HCMC',
      phone: '6868686',
      imageUrl: 'assets/images/Phuc_Long.png',
      description: '"Where every cup tells a story"',
      amenities: [
        AmenityTag(label: 'Quiet', percentage: 0.8),
        AmenityTag(label: 'Wi-Fi', percentage: 0.3),
      ],
      reviews: [
        Review(name: 'Mike', stars: 5, comment: 'Great atmosphere!'),
      ],
      rating: 4.8,
      reviewCount: 130,
    ),
  ));
}