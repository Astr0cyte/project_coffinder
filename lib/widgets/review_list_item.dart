import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/cafe_service.dart';
import 'coffee_shop_card.dart';

/// Bọc quanh CoffeeShopCard: nhận 1 ReviewModel, tự lấy tên quán từ
/// collection `cafes` bằng cafe_id rồi render ra card.
class ReviewListItem extends StatelessWidget {
  final ReviewModel review;

  const ReviewListItem({super.key, required this.review});

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
    return FutureBuilder(
      future: CafeService.instance.getCafe(review.cafeId),
      builder: (context, snapshot) {
        final cafeName = snapshot.connectionState == ConnectionState.waiting
            ? 'Đang tải...'
            : (snapshot.data?.cafeName ?? 'Quán đã bị xoá');

        return CoffeeShopCard(
          name: cafeName,
          description: review.comment,
          rating: review.rating,
          pinned: review.pinned,
          timeAgo: _timeAgo(review.createdAt),
        );
      },
    );
  }
}