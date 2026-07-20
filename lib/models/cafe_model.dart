import 'package:cloud_firestore/cloud_firestore.dart';


class CafeModel {
  final String id;
  final String cafeName;
  final String story;
  final String openTime;
  final String createdBy;
  final List<String> features;
  final List<String> signatureDrinks;
  final List<String> vibes;
  final String area;
  final String address;
  final String imageUrl;
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
    this.area = '',
    this.address = '',
    this.imageUrl = '',
    this.createdAt,
  });

  factory CafeModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? <String, dynamic>{};
    return CafeModel(
      id: doc.id,
      cafeName: _str(map['cafeName']),
      story: _str(map['story']),
      openTime: _str(map['openTime']),
      createdBy: _str(map['createdBy']),
      features: _strList(map['features']),
      signatureDrinks: _strList(map['signatureDrinks']),
      vibes: _strList(map['vibes']),
      area: _str(map['area']),
      address: _str(map['address']),
      imageUrl: _str(map['imageUrl']),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  static String _str(dynamic v) => v is String ? v : '';
  static List<String> _strList(dynamic v) =>
      v is List ? v.whereType<String>().toList() : [];
}