import 'package:flutter/material.dart';
import '../models/cafe_model.dart';
import '../pages/coffee_shop_detail_screen.dart';
import 'coffee_shop_card.dart';


class CafePostItem extends StatelessWidget {
  final CafeModel cafe;

  const CafePostItem({super.key, required this.cafe});

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return CoffeeShopCard(
      name: cafe.cafeName,
      description: cafe.story.isNotEmpty ? cafe.story : cafe.address,
      imageUrl: cafe.imageUrl,
      timeAgo: _timeAgo(cafe.createdAt),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CoffeeShopDetailScreen(cafe: cafe),
        ),
      ),
    );
  }
}