import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cafe_model.dart';
import '../models/review_model.dart';
import '../services/cafe_service.dart';
import '../services/follow_service.dart';
import '../services/review_service.dart';
import '../services/user_service.dart';
import 'app_colors.dart';
import 'coffee_shop_detail_screen.dart';

// A unified feed item — either a cafe post or a review.
sealed class _FeedItem {
  DateTime? get createdAt;
}

class _CafeItem extends _FeedItem {
  final CafeModel cafe;
  final String username;
  _CafeItem(this.cafe, this.username);
  @override
  DateTime? get createdAt => cafe.createdAt;
}

class _ReviewItem extends _FeedItem {
  final ReviewModel review;
  final String cafeName;
  final CafeModel? cafe;
  _ReviewItem(this.review, this.cafeName, this.cafe);
  @override
  DateTime? get createdAt => review.createdAt;
  String get username => review.displayName;
}

class ActivityFeedPage extends StatefulWidget {
  const ActivityFeedPage({super.key});

  @override
  State<ActivityFeedPage> createState() => _ActivityFeedPageState();
}

class _ActivityFeedPageState extends State<ActivityFeedPage> {
  List<_FeedItem> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() { _loading = false; _items = []; });
        return;
      }

      final followedUids = await FollowService.instance.getFollowedUids(uid);

      final cafesFuture = CafeService.instance.getCafesByCreators(followedUids);
      final reviewsFuture = ReviewService.instance.getReviewsByUsers(followedUids);
      final results = await Future.wait([cafesFuture, reviewsFuture]);

      final cafes = results[0] as List<CafeModel>;
      final reviews = results[1] as List<ReviewModel>;

      // Batch-fetch usernames and cafe names in parallel.
      final cafeIds = reviews.map((r) => r.cafeId).toSet().toList();
      final cafeModelMap = <String, CafeModel>{};
      final usernameMap = <String, String>{};

      await Future.wait([
        ...cafeIds.map((id) async {
          final cafe = await CafeService.instance.getCafe(id);
          if (cafe != null) cafeModelMap[id] = cafe;
        }),
        ...followedUids.map((uid) async {
          final user = await UserService.instance.getUser(uid);
          usernameMap[uid] = user.displayName;
        }),
      ]);

      final items = <_FeedItem>[
        ...cafes.map((c) => _CafeItem(c, usernameMap[c.createdBy] ?? 'Someone')),
        ...reviews.map((r) => _ReviewItem(
              r,
              cafeModelMap[r.cafeId]?.cafeName ?? 'a cafe',
              cafeModelMap[r.cafeId],
            )),
      ];

      items.sort((a, b) {
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      if (mounted) setState(() { _items = items; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: AppColors.brownDark,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Following Activity',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brownDark,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.tan, height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Could not load feed:\n$_error',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  fontSize: 13, color: AppColors.brownMid),
                            ),
                          ),
                        )
                      : _items.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(
                                  'No activity yet.\nFollow people to see their posts here.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.brownMid,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _load,
                              color: AppColors.brownDark,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                itemCount: _items.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, i) {
                                  final item = _items[i];
                                  final time = _timeAgo(item.createdAt);
                                  return switch (item) {
                                    _CafeItem(:final cafe, :final username) =>
                                      _CafeActivityCard(cafe: cafe, username: username, timeAgo: time),
                                    _ReviewItem(:final review, :final cafeName, :final cafe) =>
                                      _ReviewActivityCard(
                                          review: review,
                                          cafeName: cafeName,
                                          cafe: cafe,
                                          timeAgo: time),
                                  };
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CafeActivityCard extends StatelessWidget {
  final CafeModel cafe;
  final String username;
  final String timeAgo;

  const _CafeActivityCard({required this.cafe, required this.username, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CoffeeShopDetailScreen(cafe: cafe)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: cafe.imageUrl.isNotEmpty
                  ? Image.network(cafe.imageUrl,
                      width: 90, height: 90, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(width: 90, height: 90, color: AppColors.tan))
                  : Container(width: 90, height: 90, color: AppColors.tan),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$username posted a new cafe',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.brownMid)),
                    const SizedBox(height: 3),
                    Text(cafe.cafeName,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brownDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(cafe.area.isNotEmpty ? cafe.area : cafe.address,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.brownMid),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(timeAgo,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.brownMid)),
                  const SizedBox(height: 4),
                  const Icon(Icons.chevron_right, color: AppColors.brownMid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewActivityCard extends StatelessWidget {
  final ReviewModel review;
  final String cafeName;
  final CafeModel? cafe;
  final String timeAgo;

  const _ReviewActivityCard({
    required this.review,
    required this.cafeName,
    this.cafe,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cafe == null
          ? null
          : () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CoffeeShopDetailScreen(cafe: cafe!),
                ),
              ),
      child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${review.displayName} reviewed $cafeName',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.brownMid),
                ),
              ),
              Text(timeAgo,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.brownMid)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < review.rating ? Icons.star : Icons.star_border,
                size: 14,
                color: const Color(0xFFF5B301),
              ),
            ),
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.comment,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.brownDark, height: 1.4),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
    );
  }
}