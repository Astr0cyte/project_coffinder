import 'package:cloud_firestore/cloud_firestore.dart';

class Cafe {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final GeoPoint address;
  final Timestamp openingHours;
  final double averageRating;
  final int reviewCount;
  final List<String> tags;

  Cafe({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.openingHours,
    required this.averageRating,
    required this.reviewCount,
    required this.tags,
  });

  factory Cafe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Cafe(
      id: doc.id,
      name: data["cafe_name"] ?? "",
      description: data["description"] ?? "",
      imageUrl: data["image_url"] ?? "",
      address: data["address"],
      openingHours: data["opening_hours"],
      averageRating: (data["average_rating"] ?? 0).toDouble(),
      reviewCount: data["review_count"] ?? 0,
      tags: List<String>.from(data["tags"] ?? []),
    );
  }
}