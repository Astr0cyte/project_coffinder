import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../states/review_state.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> postReview({
    required String cafeId,
    required String cafeName,
    required ReviewState review,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not signed in");
    }

    final reviewRef = _firestore.collection("reviews").doc();

    await reviewRef.set({
      "review_id": reviewRef.id,
      "cafe_id": cafeId,
      "cafe_name": cafeName,
      "user_id": user.uid,
      "user_name": user.displayName ?? "",

      "comment": review.experience,

      "rating": review.rating,

      "created_at": FieldValue.serverTimestamp(),

      // Store selected features
      "features": review.selectedFeatures,

      // If you're using this field
      "draft_reviews": "",
    });
  }
}