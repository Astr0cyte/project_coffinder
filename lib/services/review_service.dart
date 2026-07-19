import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  ReviewService._();
  static final ReviewService instance = ReviewService._();

  final _reviewsRef = FirebaseFirestore.instance.collection('reviews');

  /// Lắng nghe realtime toàn bộ review do 1 user tạo, mới nhất lên trước.
  /// LƯU Ý: query where + orderBy trên 2 field khác nhau (user_id, created_at)
  /// sẽ yêu cầu Firestore tạo Composite Index. Lần chạy đầu tiên nếu lỗi,
  /// console sẽ log ra 1 đường link -> bấm vào đó để tự tạo index (mất ~1 phút).
  Stream<List<ReviewModel>> streamUserReviews(String uid) {
    return _reviewsRef
        .where('user_id', isEqualTo: uid)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => ReviewModel.fromSnapshot(d)).toList());
  }

  Future<void> createReview({
    required String uid,
    required String cafeId,
    required String comment,
    required int rating,
    bool pinned = false,
  }) {
    return _reviewsRef.add({
      'user_id': uid,
      'cafe_id': cafeId,
      'comment': comment,
      'rating': rating,
      'pinned': pinned,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteReview(String reviewId) {
    return _reviewsRef.doc(reviewId).delete();
  }
}