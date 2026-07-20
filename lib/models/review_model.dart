import 'package:cloud_firestore/cloud_firestore.dart';

/// Đại diện cho 1 document trong collection `reviews`.
/// Field chắc chắn có (thấy trong Firestore Console): user_id, cafe_id, created_at.
/// Field mình GIẢ ĐỊNH thêm để phục vụ UI (sửa lại tên nếu schema thật khác):
/// rating (số hạt cà phê), comment (nội dung review), pinned (có ghim làm "yêu thích" không).
class ReviewModel {
  final String id;
  final String userId;
  final String cafeId;
  final String displayName;
  final String comment;
  final int rating;
  final bool pinned;
  final DateTime? createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.cafeId,
    required this.displayName,
    required this.comment,
    required this.rating,
    required this.pinned,
    this.createdAt,
  });

  factory ReviewModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? <String, dynamic>{};
    return ReviewModel(
      id: doc.id,
      userId: map['user_id'] ?? '',
      cafeId: map['cafe_id'] ?? '',
      displayName: map['display_name'] ?? 'Anonymous',
      comment: map['comment'] ?? '',
      rating: (map['rating'] ?? 0) is int
          ? (map['rating'] ?? 0) as int
          : (map['rating'] as num).toInt(),
      pinned: map['pinned'] ?? false,
      createdAt: map['created_at'] is Timestamp
          ? (map['created_at'] as Timestamp).toDate()
          : null,
    );
  }
}