import 'package:cloud_firestore/cloud_firestore.dart';

/// Quản lý quan hệ follow giữa các user qua collection `follows`.
/// Mỗi document ID có dạng "{follower_id}_{following_id}" -> check
/// đang follow hay chưa chỉ cần đọc đúng 1 document, không cần query.
class FollowService {
  FollowService._();
  static final FollowService instance = FollowService._();

  final _followsRef = FirebaseFirestore.instance.collection('follows');

  String _followId(String followerId, String followingId) =>
      '${followerId}_$followingId';

  /// Lắng nghe realtime: currentUid có đang follow targetUid không.
  Stream<bool> streamIsFollowing(String followerId, String followingId) {
    return _followsRef
        .doc(_followId(followerId, followingId))
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> followUser(String followerId, String followingId) async {
    // Không cho tự follow chính mình.
    if (followerId == followingId) return;
    await _followsRef.doc(_followId(followerId, followingId)).set({
      'follower_id': followerId,
      'following_id': followingId,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unfollowUser(String followerId, String followingId) {
    return _followsRef.doc(_followId(followerId, followingId)).delete();
  }

  /// Đếm số người đang follow uid này (dùng aggregation query,
  /// không tốn quota đọc từng document).
  Future<int> countFollowers(String uid) async {
    final snap =
    await _followsRef.where('following_id', isEqualTo: uid).count().get();
    return snap.count ?? 0;
  }

  /// Đếm số người mà uid này đang follow.
  Future<int> countFollowing(String uid) async {
    final snap =
    await _followsRef.where('follower_id', isEqualTo: uid).count().get();
    return snap.count ?? 0;
  }

  /// Real-time follower count — updates instantly after follow/unfollow.
  Stream<int> streamFollowerCount(String uid) {
    return _followsRef
        .where('following_id', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.size);
  }

  /// Real-time following count — updates instantly after follow/unfollow.
  Stream<int> streamFollowingCount(String uid) {
    return _followsRef
        .where('follower_id', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.size);
  }
}