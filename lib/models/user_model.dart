import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String userName;
  final String email;
  final String photoUrl;
  final String profileImage;
  final String role;
  final int favoriteCafeCount;
  final String pinnedCafeId;
  final DateTime? createdAt;

  UserModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.photoUrl,
    required this.profileImage,
    required this.role,
    required this.favoriteCafeCount,
    this.pinnedCafeId = '',
    this.createdAt,
  });

  String get avatarUrl => profileImage.isNotEmpty ? profileImage : photoUrl;


  String get displayName => userName.isNotEmpty ? userName : 'New User';

  factory UserModel.empty(String uid) {
    return UserModel(
      userId: uid,
      userName: '',
      email: '',
      photoUrl: '',
      profileImage: '',
      role: '',
      favoriteCafeCount: 0,
      createdAt: null,
    );
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      userId: (map['user_id'] as String?)?.isNotEmpty == true
          ? map['user_id'] as String
          : uid,
      userName: map['user_name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photo_url'] ?? '',
      profileImage: map['profileImage'] ?? '',
      role: map['role'] ?? '',
      favoriteCafeCount: (map['favorite_cafe_count'] ?? 0) as int,
      pinnedCafeId: map['pinnedCafeId'] ?? '',
      createdAt: map['created_at'] is Timestamp
          ? (map['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (!doc.exists || doc.data() == null) {
      return UserModel.empty(doc.id);
    }
    return UserModel.fromMap(doc.id, doc.data()!);
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'email': email,
      'photo_url': photoUrl,
      'profileImage': profileImage,
      'role': role,
      'favorite_cafe_count': favoriteCafeCount,
      'pinnedCafeId': pinnedCafeId,
      'created_at':
      createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? userName,
    String? email,
    String? photoUrl,
    String? profileImage,
    String? role,
    int? favoriteCafeCount,
    String? pinnedCafeId,
  }) {
    return UserModel(
      userId: userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      favoriteCafeCount: favoriteCafeCount ?? this.favoriteCafeCount,
      pinnedCafeId: pinnedCafeId ?? this.pinnedCafeId,
      createdAt: createdAt,
    );
  }
}