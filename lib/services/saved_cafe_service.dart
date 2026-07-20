import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cafe_model.dart';
import 'cafe_service.dart';

class SavedCafeService {
  SavedCafeService._();
  static final SavedCafeService instance = SavedCafeService._();

  CollectionReference<Map<String, dynamic>> _ref(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('saved_cafes');

  Stream<bool> streamIsSaved(String uid, String cafeId) =>
      _ref(uid).doc(cafeId).snapshots().map((s) => s.exists);

  Future<void> save(String uid, String cafeId) =>
      _ref(uid).doc(cafeId).set({'saved_at': FieldValue.serverTimestamp()});

  Future<void> unsave(String uid, String cafeId) =>
      _ref(uid).doc(cafeId).delete();

  Future<void> toggle(String uid, String cafeId) async {
    final doc = await _ref(uid).doc(cafeId).get();
    if (doc.exists) {
      await unsave(uid, cafeId);
    } else {
      await save(uid, cafeId);
    }
  }

  Stream<List<String>> streamSavedIds(String uid) => _ref(uid)
      .orderBy('saved_at', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.id).toList());

  Stream<List<CafeModel>> streamSavedCafes(String uid) async* {
    await for (final ids in streamSavedIds(uid)) {
      final cafes = await Future.wait(ids.map(CafeService.instance.getCafe));
      yield cafes.whereType<CafeModel>().toList();
    }
  }
}
