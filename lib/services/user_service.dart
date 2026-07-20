import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Quản lý đọc/ghi document user trong collection `users`.
/// Dùng cùng với AuthService (Firebase Auth chỉ quản lý đăng nhập,
/// còn thông tin hồ sơ như user_name, photo_url... nằm ở Firestore).
class UserService {
  UserService._();
  static final UserService instance = UserService._();

  final _usersRef = FirebaseFirestore.instance.collection('users');

  /// Lắng nghe realtime thông tin user theo uid.
  /// Dùng với StreamBuilder để UI tự cập nhật khi Firestore thay đổi.
  Stream<UserModel> streamUser(String uid) {
    return _usersRef.doc(uid).snapshots().map(
          (snap) => UserModel.fromSnapshot(snap),
    );
  }

  /// Lấy thông tin user 1 lần (không realtime).
  Future<UserModel> getUser(String uid) async {
    final snap = await _usersRef.doc(uid).get();
    return UserModel.fromSnapshot(snap);
  }

  /// Gọi sau khi đăng ký / đăng nhập lần đầu để tạo document user
  /// nếu chưa tồn tại (tránh bị null khi vào ProfilePage).
  Future<void> createUserIfNotExists({
    required String uid,
    required String email,
    String userName = '',
  }) async {
    final doc = _usersRef.doc(uid);
    final snap = await doc.get();
    if (!snap.exists) {
      await doc.set(
        UserModel(
          userId: uid,
          userName: userName,
          email: email,
          photoUrl: '',
          profileImage: '',
          role: 'user',
          favoriteCafeCount: 0,
          createdAt: DateTime.now(),
        ).toMap(),
      );
    }
  }

  /// Cập nhật 1 hoặc nhiều field tùy ý, vd:
  /// updateUser(uid, {'user_name': 'John'});
  Future<void> updateUser(String uid, Map<String, dynamic> data) {
    return _usersRef.doc(uid).update(data);
  }

  Future<void> updateProfileImage(String uid, String imageUrl) {
    return _usersRef.doc(uid).update({'profileImage': imageUrl});
  }

  Future<void> pinCafe(String uid, String cafeId) =>
      _usersRef.doc(uid).update({'pinnedCafeId': cafeId});

  Future<void> unpinCafe(String uid) =>
      _usersRef.doc(uid).update({'pinnedCafeId': ''});

  Future<void> incrementFavoriteCafeCount(String uid, {int by = 1}) {
    return _usersRef.doc(uid).update({
      'favorite_cafe_count': FieldValue.increment(by),
    });
  }

  /// Fetches all users and filters client-side — no index required,
  /// case-insensitive, substring match on name and email.
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];
    final q = query.trim().toLowerCase();
    final snap = await _usersRef.limit(300).get();
    return snap.docs
        .map((d) => UserModel.fromSnapshot(d))
        .where((u) => u.userName.toLowerCase().contains(q))
        .toList();
  }
}