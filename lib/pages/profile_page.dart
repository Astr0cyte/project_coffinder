import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/review_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/follow_service.dart';
import '../services/review_service.dart';
import '../services/user_service.dart';
import '../widgets/follow_button.dart';
import '../widgets/profile_stat.dart';
import '../widgets/review_list_item.dart';
import 'settings_popup.dart';

class ProfilePage extends StatefulWidget {
  /// uid của profile đang xem. Null = đang xem profile của chính mình.
  /// Khi mở profile người khác, gọi:
  /// Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(userId: otherUid)));
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Tăng biến này để ép FutureBuilder đếm lại followers sau khi follow/unfollow.
  int _followRefreshTick = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.instance.currentUser;

    // Chưa đăng nhập (hoặc đang ở chế độ khách) -> không có uid để load Firestore
    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFFAF9F4),
        body: Center(child: Text('Bạn chưa đăng nhập')),
      );
    }

    // profileUid: uid của profile đang hiển thị.
    // isOwnProfile: false thì mới cho hiện nút Follow (không tự follow bản thân).
    final profileUid = widget.userId ?? currentUser.uid;
    final isOwnProfile = profileUid == currentUser.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F4),
      body: SafeArea(
        child: StreamBuilder<UserModel>(
          // Lắng nghe realtime document users/{uid} trên Firestore.
          // Mỗi khi dữ liệu đổi (vd sau khi Settings cập nhật tên/ảnh),
          // UI ở đây tự vẽ lại mà không cần setState thủ công.
          stream: UserService.instance.streamUser(profileUid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Lỗi tải hồ sơ: ${snapshot.error}'));
            }

            final user = snapshot.data ?? UserModel.empty(profileUid);

            // Nested StreamBuilder: lắng nghe toàn bộ review của profile đang xem.
            // Tách riêng khỏi user data vì đây là 2 collection khác nhau.
            return StreamBuilder<List<ReviewModel>>(
              stream: ReviewService.instance.streamUserReviews(profileUid),
              builder: (context, reviewSnapshot) {
                final reviews = reviewSnapshot.data ?? [];
                final pinned = reviews.where((r) => r.pinned).toList();
                final history = reviews.where((r) => !r.pinned).toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildHeader(
                          context,
                          user,
                          postCount: reviews.length,
                          profileUid: profileUid,
                          isOwnProfile: isOwnProfile,
                        ),
                        const SizedBox(height: 20.0),
                        if (!isOwnProfile)
                          FollowButton(
                            currentUid: currentUser.uid,
                            targetUid: profileUid,
                            onChanged: () =>
                                setState(() => _followRefreshTick++),
                          ),
                        const SizedBox(height: 20.0),
                        const Divider(color: Color(0xFFDED4BA), thickness: 1),
                        const SizedBox(height: 5.0),

                        _sectionTitle('Favourite Coffee Shop'),
                        const SizedBox(height: 8),
                        if (reviewSnapshot.connectionState ==
                            ConnectionState.waiting)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: CircularProgressIndicator(),
                          )
                        else if (pinned.isEmpty)
                          _emptyState('Chưa có quán cà phê yêu thích nào.')
                        else
                          ...pinned.map(
                                (r) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ReviewListItem(review: r),
                            ),
                          ),

                        const SizedBox(height: 25),
                        _sectionTitle('Post History'),
                        const SizedBox(height: 12),
                        if (reviewSnapshot.connectionState ==
                            ConnectionState.waiting)
                          const SizedBox.shrink()
                        else if (history.isEmpty)
                          _emptyState('Chưa có bài đăng nào.')
                        else
                          ...history.map(
                                (r) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ReviewListItem(review: r),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Text hiển thị khi 1 section chưa có dữ liệu (không phải lỗi, chỉ là rỗng).
  Widget _emptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(0xFF7E654C),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context,
      UserModel user, {
        required int postCount,
        required String profileUid,
        required bool isOwnProfile,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onPressed: () => Navigator.pop(context),
            ),
            const Spacer(),
            // Chỉ chủ tài khoản mới thấy nút Settings của chính họ.
            if (isOwnProfile)
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                color: const Color(0xFF402F11),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const SettingsPopup(),
                  );
                },
              ),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: CircleAvatar(
            radius: 35,
            backgroundColor: const Color(0xFFDED4BA),
            backgroundImage: user.avatarUrl.isNotEmpty
                ? NetworkImage(user.avatarUrl) as ImageProvider
                : const AssetImage('assets/avatar.png'),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            user.displayName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'PlayfairDisplay',
              color: Color(0xFF402F11),
            ),
          ),
        ),
        Center(
          child: Text(
            user.email.isNotEmpty ? user.email : '@Username',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Quicksand',
              color: Color(0xFF7E654C),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Center(
          child: Text(
            user.role.isNotEmpty ? user.role : 'Coffee app',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              color: Color(0xFF7E654C),
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileStat(value: '$postCount', label: 'Posts'),
            const SizedBox(width: 16.0),
            FutureBuilder<int>(
              key: ValueKey('followers_${profileUid}_$_followRefreshTick'),
              future: FollowService.instance.countFollowers(profileUid),
              builder: (context, snap) {
                return ProfileStat(
                  value: '${snap.data ?? 0}',
                  label: 'Followers',
                );
              },
            ),
            const SizedBox(width: 16.0),
            // Đây là số liệu thật duy nhất có sẵn trong schema hiện tại.
            ProfileStat(
              value: '${user.favoriteCafeCount}',
              label: 'Favourites',
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF402F11),
        ),
      ),
    );
  }
}