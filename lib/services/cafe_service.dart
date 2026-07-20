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