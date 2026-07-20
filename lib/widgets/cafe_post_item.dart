import 'package:flutter/material.dart';
import '../models/cafe_model.dart';
import 'coffee_shop_card.dart';


class CafePostItem extends StatelessWidget {
  final CafeModel cafe;

  const CafePostItem({super.key, required this.cafe});

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 1) return '${diff.inDays} ngày trước';
    if (diff.inHours >= 1) return '${diff.inHours} giờ trước';
    if (diff.inMinutes >= 1) return '${diff.inMinutes} phút trước';
    return 'Vừa xong';
  }

  @override
  Widget build(BuildContext context) {
    return CoffeeShopCard(
      name: cafe.cafeName,
      description: cafe.story.isNotEmpty ? cafe.story : cafe.address,
      imageUrl: cafe.imageUrl,
      timeAgo: _timeAgo(cafe.createdAt),
    );
  }
}