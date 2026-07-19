import 'package:cloud_firestore/cloud_firestore.dart';

/// Đại diện cho 1 document trong collection `cafes`, khớp với các field
/// thấy trong Firestore Console: cafeName, createdAt, createdBy, features,
/// openTime, signatureDrinks, story, vibes.
class CafeModel {
  final String id;
  final String cafeName;
  final String story;
  final String openTime;
  final String createdBy;
  final List<String> features;
  final List<String> signatureDrinks;
  final List<String> vibes;
  final DateTime? createdAt;

  CafeModel({
    required this.id,
    required this.cafeName,
    required this.story,
    required this.openTime,
    required this.createdBy,
    required this.features,
    required this.signatureDrinks,
    required this.vibes,
    this.createdAt,
  });

  factory CafeModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? <String, dynamic>{};
    return CafeModel(
      id: doc.id,
      cafeName: map['cafeName'] ?? '',
      story: map['story'] ?? '',
      openTime: map['openTime'] ?? '',
      createdBy: map['createdBy'] ?? '',
      features: List<String>.from(map['features'] ?? const []),
      signatureDrinks: List<String>.from(map['signatureDrinks'] ?? const []),
      vibes: List<String>.from(map['vibes'] ?? const []),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}