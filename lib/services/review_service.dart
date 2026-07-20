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
        .snapshots()
        .map((snap) {
          final reviews = snap.docs
              .map((d) => ReviewModel.fromSnapshot(d))
              .toList();
          reviews.sort((a, b) {
            if (a.createdAt == null && b.createdAt == null) return 0;
            if (a.createdAt == null) return 1;
            if (b.createdAt == null) return -1;
            return b.createdAt!.compareTo(a.createdAt!);
          });
          return reviews;
        });
  }

  Stream<List<ReviewModel>> streamCafeReviews(String cafeId) {
    return _reviewsRef
        .where('cafe_id', isEqualTo: cafeId)
        .snapshots()
        .map((snap) {
          final reviews = snap.docs
              .map((d) => ReviewModel.fromSnapshot(d))
              .toList();
          reviews.sort((a, b) {
            if (a.createdAt == null && b.createdAt == null) return 0;
            if (a.createdAt == null) return 1;
            if (b.createdAt == null) return -1;
            return b.createdAt!.compareTo(a.createdAt!);
          });
          return reviews;
        });
  }

  /// Fetches reviews posted by [uids], sorted newest first.
  /// Batches into chunks of 30 to stay within Firestore whereIn limits.
  Future<List<ReviewModel>> getReviewsByUsers(List<String> uids) async {
    if (uids.isEmpty) return [];
    const chunkSize = 30;
    final results = <ReviewModel>[];
    for (var i = 0; i < uids.length; i += chunkSize) {
      final chunk = uids.sublist(i, (i + chunkSize).clamp(0, uids.length));
      final snap = await _reviewsRef
          .where('user_id', whereIn: chunk)
          .get();
      results.addAll(snap.docs.map((d) => ReviewModel.fromSnapshot(d)));
    }
    results.sort((a, b) {
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });
    return results;
  }

  Future<void> createReview({
    required String uid,
    required String cafeId,
    required String displayName,
    required String comment,
    required int rating,
    bool pinned = false,
  }) async {
    final cafeRef = FirebaseFirestore.instance.collection('cafes').doc(cafeId);
    final reviewRef = _reviewsRef.doc();

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final cafeSnap = await tx.get(cafeRef);
      final data = cafeSnap.data() ?? {};
      final currentCount = (data['reviewCount'] as num?)?.toInt() ?? 0;
      final currentAvg = (data['averageRating'] as num?)?.toDouble() ?? 0.0;
      final newCount = currentCount + 1;
      final newAvg = ((currentAvg * currentCount) + rating) / newCount;

      tx.set(reviewRef, {
        'user_id': uid,
        'cafe_id': cafeId,
        'display_name': displayName,
        'comment': comment,
        'rating': rating,
        'pinned': pinned,
        'created_at': FieldValue.serverTimestamp(),
      });

      tx.update(cafeRef, {
        'averageRating': double.parse(newAvg.toStringAsFixed(1)),
        'reviewCount': newCount,
      });
    });
  }

  Future<void> deleteReview(String reviewId) {
    return _reviewsRef.doc(reviewId).delete();
  }
}