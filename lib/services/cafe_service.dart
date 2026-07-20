// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/cafe_model.dart';
//
// class CafeService {
//   CafeService._();
//   static final CafeService instance = CafeService._();
//
//   final _cafesRef = FirebaseFirestore.instance.collection('cafes');
//
//   Future<CafeModel?> getCafe(String cafeId) async {
//     if (cafeId.isEmpty) return null;
//     final doc = await _cafesRef.doc(cafeId).get();
//     if (!doc.exists) return null;
//     return CafeModel.fromSnapshot(doc);
//   }
//
//   /// Tạo 1 quán cà phê mới từ dữ liệu đã nhập qua 4 bước (AddCafeState).
//   /// imageUrl là link ảnh người dùng tự dán ở Step 1 (không upload file).
//   Future<String> createCafe({
//     required String cafeName,
//     required String area,
//     required String address,
//     required String openTime,
//     required String story,
//     required List<String> vibes,
//     required List<String> features,
//     required List<String> signatureDrinks,
//     required String createdBy,
//     String imageUrl = '',
//   }) async {
//     final docRef = _cafesRef.doc();
//
//     await docRef.set({
//       'cafeName': cafeName,
//       'area': area,
//       'address': address,
//       'openTime': openTime,
//       'story': story,
//       'vibes': vibes,
//       'features': features,
//       'signatureDrinks':
//       signatureDrinks.where((d) => d.trim().isNotEmpty).toList(),
//       'imageUrl': imageUrl,
//       'createdBy': createdBy,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//
//     return docRef.id;
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/cafe_model.dart';

class CafeService {
  CafeService._();
  static final CafeService instance = CafeService._();

  final _cafesRef = FirebaseFirestore.instance.collection('cafes');

  Future<CafeModel?> getCafe(String cafeId) async {
    if (cafeId.isEmpty) return null;
    final doc = await _cafesRef.doc(cafeId).get();
    if (!doc.exists) return null;
    return CafeModel.fromSnapshot(doc);
  }

  /// Stream all cafes, newest first.
  Stream<List<CafeModel>> streamAllCafes() {
    return _cafesRef
        .snapshots()
        .map((snap) {
          final cafes = <CafeModel>[];
          for (final doc in snap.docs) {
            try {
              cafes.add(CafeModel.fromSnapshot(doc));
            } catch (e) {
              debugPrint('Skipping malformed cafe doc ${doc.id}: $e');
            }
          }
          cafes.sort((a, b) {
            if (a.createdAt == null && b.createdAt == null) return 0;
            if (a.createdAt == null) return 1;
            if (b.createdAt == null) return -1;
            return b.createdAt!.compareTo(a.createdAt!);
          });
          return cafes;
        });
  }

  /// Lắng nghe realtime toàn bộ quán do 1 user đăng (Post History thật sự).
  /// LƯU Ý: where + orderBy khác field -> cần Composite Index, Firestore sẽ
  /// tự log ra link tạo index nếu chưa có, bấm vào đó là xong.
  Stream<List<CafeModel>> streamUserCafes(String uid) {
    return _cafesRef
        .where('createdBy', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => CafeModel.fromSnapshot(d)).toList());
  }

  /// Fetches cafes posted by [uids], sorted newest first.
  /// Batches into chunks of 30 to stay within Firestore whereIn limits.
  Future<List<CafeModel>> getCafesByCreators(List<String> uids) async {
    if (uids.isEmpty) return [];
    const chunkSize = 30;
    final results = <CafeModel>[];
    for (var i = 0; i < uids.length; i += chunkSize) {
      final chunk = uids.sublist(i, (i + chunkSize).clamp(0, uids.length));
      final snap = await _cafesRef
          .where('createdBy', whereIn: chunk)
          .get();
      results.addAll(snap.docs.map((d) => CafeModel.fromSnapshot(d)));
    }
    results.sort((a, b) {
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });
    return results;
  }

  /// Tạo 1 quán cà phê mới từ dữ liệu đã nhập qua 4 bước (AddCafeState).
  /// imageUrl là link ảnh người dùng tự dán ở Step 1 (không upload file).
  Future<String> createCafe({
    required String cafeName,
    required String area,
    required String address,
    required String openTime,
    required String story,
    required Iterable<String> vibes,
    required Iterable<String> features,
    required List<String> signatureDrinks,
    required String createdBy,
    String imageUrl = '',
  }) async {
    final docRef = _cafesRef.doc();

    await docRef.set({
      'cafeName': cafeName,
      'area': area,
      'address': address,
      'openTime': openTime,
      'story': story,
      'vibes': vibes.toList(),
      'features': features.toList(),
      'signatureDrinks':
      signatureDrinks.where((d) => d.trim().isNotEmpty).toList(),
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }
}