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
}