// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../models/cafe_model.dart';
// import '../models/review_model.dart';
// import '../models/user_model.dart';
// import '../services/auth_service.dart';
// import '../services/cafe_service.dart';
// import '../services/follow_service.dart';
// import '../services/review_service.dart';
// import '../services/user_service.dart';
// import '../widgets/cafe_post_item.dart';
// import '../widgets/follow_button.dart';
// import '../widgets/profile_stat.dart';
// import '../widgets/review_list_item.dart';
// import 'settings_popup.dart';
//
// class ProfilePage extends StatefulWidget {
//   final String? userId;
//
//   const ProfilePage({super.key, this.userId});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   // Tăng biến này để ép FutureBuilder đếm lại followers sau khi follow/unfollow.
//   int _followRefreshTick = 0;
//
//   // Cache stream theo profileUid: chỉ tạo Stream MỚI khi đổi sang xem
//   // profile khác, không tạo lại mỗi lần build() -> tránh StreamBuilder
//   // bị reset về loading (flicker "hiện rồi biến mất").
//   String? _cachedProfileUid;
//   late Stream<UserModel> _userStream;
//   late Stream<List<ReviewModel>> _reviewStream;
//   late Stream<List<CafeModel>> _cafeStream;
//
//   void _ensureStreams(String profileUid) {
//     if (_cachedProfileUid == profileUid) return;
//     _cachedProfileUid = profileUid;
//     _userStream = UserService.instance.streamUser(profileUid);
//     _reviewStream = ReviewService.instance.streamUserReviews(profileUid);
//     _cafeStream = CafeService.instance.streamUserCafes(profileUid);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final currentUser = AuthService.instance.currentUser;
//
//     if (currentUser == null) {
//       return const Scaffold(
//         backgroundColor: Color(0xFFFAF9F4),
//         body: Center(child: Text('You are not logged in.')),
//       );
//     }
//
//     final profileUid = widget.userId ?? currentUser.uid;
//     final isOwnProfile = profileUid == currentUser.uid;
//     _ensureStreams(profileUid);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF9F4),
//       body: SafeArea(
//         child: StreamBuilder<UserModel>(
//           stream: _userStream,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error loading profile: ${snapshot.error}'));
//             }
//
//             final user = snapshot.data ?? UserModel.empty(profileUid);
//
//             // reviews: dùng cho "Favourite Coffee Shop" (review được pin).
//             // cafes: dùng cho "Post History" (quán user đã đăng) - đây là
//             // chỗ bị thiếu trước đây khiến Post History luôn trống.
//             return StreamBuilder<List<ReviewModel>>(
//               stream: _reviewStream,
//               builder: (context, reviewSnapshot) {
//                 final reviews = reviewSnapshot.data ?? [];
//                 final pinned = reviews.where((r) => r.pinned).toList();
//
//                 return StreamBuilder<List<CafeModel>>(
//                   stream: _cafeStream,
//                   builder: (context, cafeSnapshot) {
//                     final myCafes = cafeSnapshot.data ?? [];
//                     final isLoadingCafes =
//                         cafeSnapshot.connectionState == ConnectionState.waiting;
//
//                     return SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             _buildHeader(
//                               context,
//                               user,
//                               postCount: myCafes.length,
//                               profileUid: profileUid,
//                               isOwnProfile: isOwnProfile,
//                             ),
//                             const SizedBox(height: 20.0),
//                             if (!isOwnProfile)
//                               FollowButton(
//                                 currentUid: currentUser.uid,
//                                 targetUid: profileUid,
//                                 onChanged: () =>
//                                     setState(() => _followRefreshTick++),
//                               ),
//                             const SizedBox(height: 20.0),
//                             const Divider(color: Color(0xFFDED4BA), thickness: 1),
//                             const SizedBox(height: 5.0),
//
//                             _sectionTitle('Favourite Coffee Shop'),
//                             const SizedBox(height: 8),
//                             if (reviewSnapshot.connectionState ==
//                                 ConnectionState.waiting)
//                               const Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 12),
//                                 child: CircularProgressIndicator(),
//                               )
//                             else if (pinned.isEmpty)
//                               _emptyState('No favourite cafe added.')
//                             else
//                               ...pinned.map(
//                                     (r) => Padding(
//                                   padding: const EdgeInsets.only(bottom: 12),
//                                   child: ReviewListItem(review: r),
//                                 ),
//                               ),
//
//                             const SizedBox(height: 25),
//                             _sectionTitle('Post History'),
//                             const SizedBox(height: 12),
//                             if (isLoadingCafes)
//                               const Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 12),
//                                 child: CircularProgressIndicator(),
//                               )
//                             else if (myCafes.isEmpty)
//                               _emptyState('No post added.')
//                             else
//                               ...myCafes.map(
//                                     (c) => Padding(
//                                   padding: const EdgeInsets.only(bottom: 12),
//                                   child: CafePostItem(cafe: c),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _emptyState(String message) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       alignment: Alignment.center,
//       child: Text(
//         message,
//         textAlign: TextAlign.center,
//         style: GoogleFonts.inter(
//           fontSize: 12,
//           color: const Color(0xFF7E654C),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(
//       BuildContext context,
//       UserModel user, {
//         required int postCount,
//         required String profileUid,
//         required bool isOwnProfile,
//       }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back),
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//               splashColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               onPressed: () => Navigator.pop(context),
//             ),
//             const Spacer(),
//             if (isOwnProfile)
//               IconButton(
//                 icon: const Icon(Icons.settings_outlined),
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 hoverColor: Colors.transparent,
//                 color: const Color(0xFF402F11),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (_) => const SettingsPopup(),
//                   );
//                 },
//               ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         Center(
//           child: CircleAvatar(
//             radius: 35,
//             backgroundColor: const Color(0xFFDED4BA),
//             backgroundImage: user.avatarUrl.isNotEmpty
//                 ? NetworkImage(user.avatarUrl) as ImageProvider
//                 : const AssetImage('assets/avatar.png'),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Center(
//           child: Text(
//             user.displayName,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'PlayfairDisplay',
//               color: Color(0xFF402F11),
//             ),
//           ),
//         ),
//         Center(
//           child: Text(
//             user.email.isNotEmpty ? user.email : '@Username',
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               fontFamily: 'Quicksand',
//               color: Color(0xFF7E654C),
//             ),
//           ),
//         ),
//         const SizedBox(height: 4.0),
//         Center(
//           child: Text(
//             user.role.isNotEmpty ? user.role : 'Coffee app',
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//               fontFamily: 'Inter',
//               color: Color(0xFF7E654C),
//             ),
//           ),
//         ),
//         const SizedBox(height: 20.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ProfileStat(value: '$postCount', label: 'Posts'),
//             const SizedBox(width: 16.0),
//             FutureBuilder<int>(
//               key: ValueKey('followers_${profileUid}_$_followRefreshTick'),
//               future: FollowService.instance.countFollowers(profileUid),
//               builder: (context, snap) {
//                 return ProfileStat(
//                   value: '${snap.data ?? 0}',
//                   label: 'Followers',
//                 );
//               },
//             ),
//             const SizedBox(width: 16.0),
//             ProfileStat(
//               value: '${user.favoriteCafeCount}',
//               label: 'Favourites',
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _sectionTitle(String title) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: GoogleFonts.playfairDisplay(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: const Color(0xFF402F11),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/cafe_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/cafe_service.dart';
import '../services/follow_service.dart';
import '../services/review_service.dart';
import '../services/user_service.dart';
import '../widgets/cafe_post_item.dart';
import '../widgets/follow_button.dart';
import '../widgets/profile_stat.dart';
import '../widgets/review_list_item.dart';
import 'app_colors.dart';
import 'coffee_shop_detail_screen.dart';
import 'settings_popup.dart';
import 'user_search_page.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // Cache stream theo profileUid: chỉ tạo Stream MỚI khi đổi sang xem
  // profile khác, không tạo lại mỗi lần build() -> tránh StreamBuilder
  // bị reset về loading (flicker "hiện rồi biến mất").
  String? _cachedProfileUid;
  late Stream<UserModel> _userStream;
  late Stream<List<CafeModel>> _cafeStream;
  late Stream<List<ReviewModel>> _reviewStream;

  void _ensureStreams(String profileUid) {
    if (_cachedProfileUid == profileUid) return;
    _cachedProfileUid = profileUid;
    _userStream = UserService.instance.streamUser(profileUid);
    _cafeStream = CafeService.instance.streamUserCafes(profileUid);
    _reviewStream = ReviewService.instance.streamUserReviews(profileUid);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(child: Text('You are not logged in.')),
      );
    }

    final profileUid = widget.userId ?? currentUser.uid;
    final isOwnProfile = profileUid == currentUser.uid;
    _ensureStreams(profileUid);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: StreamBuilder<UserModel>(
          stream: _userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error loading profile: ${snapshot.error}'));
            }

            final user = snapshot.data ?? UserModel.empty(profileUid);

            return StreamBuilder<List<CafeModel>>(
                  stream: _cafeStream,
                  builder: (context, cafeSnapshot) {
                    final myCafes = cafeSnapshot.data ?? [];

                    return StreamBuilder<List<ReviewModel>>(
                      stream: _reviewStream,
                      builder: (context, reviewSnapshot) {
                        final myReviews = reviewSnapshot.data ?? [];
                        final isLoading =
                            cafeSnapshot.connectionState == ConnectionState.waiting ||
                            reviewSnapshot.connectionState == ConnectionState.waiting;

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildHeader(
                              context,
                              user,
                              postCount: myCafes.length + myReviews.length,
                              profileUid: profileUid,
                              isOwnProfile: isOwnProfile,
                            ),
                            const SizedBox(height: 20.0),
                            if (!isOwnProfile)
                              FollowButton(
                                currentUid: currentUser.uid,
                                targetUid: profileUid,
                              ),
                            const SizedBox(height: 20.0),
                            const Divider(color: Color(0xFFDED4BA), thickness: 1),
                            const SizedBox(height: 5.0),

                            _sectionTitle('Favourite Coffee Shop'),
                            const SizedBox(height: 8),
                            if (user.pinnedCafeId.isEmpty)
                              _emptyState('No favourite cafe pinned yet.')
                            else
                              FutureBuilder<CafeModel?>(
                                key: ValueKey(user.pinnedCafeId),
                                future: CafeService.instance.getCafe(user.pinnedCafeId),
                                builder: (context, snap) {
                                  if (snap.connectionState == ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final cafe = snap.data;
                                  if (cafe == null) return _emptyState('Pinned cafe not found.');
                                  return _pinnedCafeCard(context, cafe);
                                },
                              ),

                            const SizedBox(height: 25),
                            _sectionTitle('Post History'),
                            const SizedBox(height: 12),
                            if (isLoading)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: CircularProgressIndicator(),
                              )
                            else if (myCafes.isEmpty && myReviews.isEmpty)
                              _emptyState('No posts yet.')
                            else ...[
                              if (myCafes.isNotEmpty) ...[
                                _subSectionTitle('Coffee Shops Added'),
                                const SizedBox(height: 8),
                                ...myCafes.map((c) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: CafePostItem(cafe: c),
                                )),
                                const SizedBox(height: 8),
                              ],
                              if (myReviews.isNotEmpty) ...[
                                _subSectionTitle('Reviews'),
                                const SizedBox(height: 8),
                                ...myReviews.map((r) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ReviewListItem(review: r),
                                )),
                              ],
                            ],
                          ],
                        ),
                      ),
                    );
                      },
                    );
                  },
                );
          },
        ),
      ),
    );
  }

  Widget _subSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF7E654C),
        ),
      ),
    );
  }

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
            IconButton(
              icon: const Icon(Icons.person_search_outlined),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              color: const Color(0xFF402F11),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UserSearchPage()),
              ),
            ),
            if (isOwnProfile) ...[
              const SizedBox(width: 12),
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
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF402F11),
            ),
          ),
        ),
        if (isOwnProfile)
          Center(
            child: Text(
              user.email.isNotEmpty ? user.email : '@Username',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF7E654C),
              ),
            ),
          ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileStat(value: '$postCount', label: 'Posts'),
            const SizedBox(width: 16.0),
            StreamBuilder<int>(
              stream: FollowService.instance.streamFollowerCount(profileUid),
              builder: (context, snap) => ProfileStat(
                value: '${snap.data ?? 0}',
                label: 'Followers',
              ),
            ),
            const SizedBox(width: 16.0),
            StreamBuilder<int>(
              stream: FollowService.instance.streamFollowingCount(profileUid),
              builder: (context, snap) => ProfileStat(
                value: '${snap.data ?? 0}',
                label: 'Following',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pinnedCafeCard(BuildContext context, CafeModel cafe) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CoffeeShopDetailScreen(cafe: cafe)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFDED4BA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDED4BA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cafe.imageUrl.isNotEmpty
                  ? Image.network(
                      cafe.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          width: 90, height: 90, color: AppColors.brownMid),
                    )
                  : Container(width: 90, height: 90, color: AppColors.brownMid),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.push_pin, size: 13, color: AppColors.brownMid),
                        const SizedBox(width: 4),
                        Text(
                          'My Favourite',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.brownMid),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cafe.cafeName,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF402F11),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cafe.address.isNotEmpty ? cafe.address : cafe.area,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.brownMid),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (i) => Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Icon(
                          Icons.coffee,
                          size: 14,
                          color: i < cafe.averageRating.round()
                              ? const Color(0xFF7E654C)
                              : const Color(0xFFB8A78A),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.brownMid),
          ],
        ),
        ),
      ),
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