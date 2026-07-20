import 'dart:async';

import 'package:brewstreet_app/pages/login_page.dart';

import 'diary_page.dart';
import 'add_cafe/step1_picture_page.dart';
import '../models/cafe_model.dart';
import '../services/cafe_service.dart';
import '../states/add_cafe_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'coffee_shop_detail_screen.dart';
import 'profile_page.dart';
import 'sign_in_page.dart';
import 'register_page.dart';
import '../widgets/shop_card.dart';

class ShopListItem {
  final String name;
  final Color bgColor;
  final bool favorited;
  final String distance;
  final List<String> amenities;
  final String imageUrl;
  const ShopListItem(this.name, this.bgColor, this.favorited, this.distance, this.amenities, {this.imageUrl = ''});

  /// Text/icon color that stays readable against [bgColor].
  Color contentColor(BuildContext context) {
    final brightness = ThemeData.estimateBrightnessForColor(bgColor);
    return brightness == Brightness.dark ? AppColors.cream : AppColors.brownDark;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const filterLabels = ['All', 'Quiet', 'Wi-Fi', 'A/C', 'Pets', 'Friendly'];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double designWidth = 402;
  static const _cardColors = [
    AppColors.brownMid,
    AppColors.cardBg,
    AppColors.brownDark,
    AppColors.tan,
    AppColors.chipLight,
  ];

  bool _navVisible = true;
  double _lastOffset = 0;
  String _activeFilter = 'All';
  bool _searchOpen = false;
  final _searchController = TextEditingController();

  List<CafeModel> _cafes = [];
  bool _loading = true;
  String? _error;
  late final StreamSubscription<List<CafeModel>> _cafesSub;

  @override
  void initState() {
    super.initState();
    _cafesSub = CafeService.instance.streamAllCafes().listen(
      (cafes) {
        if (mounted) setState(() { _cafes = cafes; _loading = false; _error = null; });
      },
      onError: (e) {
        debugPrint('streamAllCafes error: $e');
        if (mounted) setState(() { _loading = false; _error = e.toString(); });
      },
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cafesSub.cancel();
    super.dispose();
  }

  bool _handleScroll(ScrollNotification notification) {
    final offset = notification.metrics.pixels;
    final max = notification.metrics.maxScrollExtent;
    final delta = offset - _lastOffset;
    if (offset <= 0 || offset >= max) {
      if (!_navVisible) setState(() => _navVisible = true);
    } else if (delta > 6 && _navVisible) {
      setState(() => _navVisible = false);
    } else if (delta < -6 && !_navVisible) {
      setState(() => _navVisible = true);
    }
    _lastOffset = offset;
    return false;
  }


  List<CafeModel> get _visibleCafes {
    if (_activeFilter == 'All') return _cafes;
    return _cafes.where((c) => c.features.contains(_activeFilter)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      extendBody: true,
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = constraints.maxWidth / designWidth;
            return NotificationListener<ScrollNotification>(
              onNotification: _handleScroll,
              child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(context, scale)),
                //SliverToBoxAdapter(child: _resultsLabel(scale)),
                SliverToBoxAdapter(child: _filterChips(scale)),
                if (_loading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_error != null)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Could not load cafes:\n$_error',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: AppColors.brownMid, fontSize: 13),
                        ),
                      ),
                    ),
                  )
                else ...[
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(20 * scale, 12 * scale, 20 * scale, 0),
                  sliver: SliverList.separated(
                    itemCount: _visibleCafes.length,
                    separatorBuilder: (_, __) => SizedBox(height: 14 * scale),
                    itemBuilder: (context, i) {
                      final cafe = _visibleCafes[i];
                      return ShopCard(
                        shop: ShopListItem(
                          cafe.cafeName,
                          _cardColors[i % _cardColors.length],
                          false,
                          cafe.area,
                          cafe.features,
                          imageUrl: cafe.imageUrl,
                        ),
                        scale: scale,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CoffeeShopDetailScreen(cafe: cafe),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20 * scale, 16 * scale, 20 * scale, 110 * scale),
                    child: Text(
                      '${_visibleCafes.length} Coffeeshops Found',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13 * scale,
                        color: AppColors.brownMid,
                      ),
                    ),
                  ),
                ),
                ], // end else
              ],
            ),
            );
          },
        ),
      ),
    );
  }

  // --- Header: profile row + brand title -----------------------------------
  Widget _header(BuildContext context, double s) {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;
    return Padding(
      padding: EdgeInsets.fromLTRB(22 * s, 20 * s, 22 * s, 4 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44 * s,
                height: 44 * s,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.chipLight, shape: BoxShape.circle),
                child: Icon(Icons.coffee, size: 22 * s, color: AppColors.brownDark),
              ),
              SizedBox(width: 12 * s),
              if (isGuest) ...[
                const Spacer(),
                _authButton(
                  label: 'Login',
                  filled: false,
                  scale: s,
                  onTap: () => _openAuthPage(const SignInPage()),
                ),
                SizedBox(width: 8 * s),
                _authButton(
                  label: 'Sign up',
                  filled: true,
                  scale: s,
                  onTap: () => _openAuthPage(const RegisterPage()),
                ),
              ] else ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hello,',
                        style: GoogleFonts.inter(fontSize: 14 * s, color: AppColors.brownMid),
                      ),
                      Text(
                        (user.displayName?.trim().isNotEmpty ?? false)
                            ? user.displayName!
                            : 'there',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 17 * s,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brownDark,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8 * s),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifications tapped')),
                    );
                  },
                  child: Container(
                    width: 44 * s,
                    height: 44 * s,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.chipLight, shape: BoxShape.circle),
                    child: Icon(Icons.notifications_none, size: 20 * s, color: AppColors.brownDark),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 4 * s),
          Text(
            'BrewStreet',
            style: GoogleFonts.playfairDisplay(
              fontSize: 40 * s,
              fontWeight: FontWeight.w600,
              color: AppColors.brownTitle,
            ),
          ),
        ],
      ),
    );
  }

  
  

  Future<void> _openAuthPage(Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
    // Refresh the header in case the user signed in / registered.
    if (mounted) setState(() {});
  }

  Widget _authButton({
    required String label,
    required bool filled,
    required double scale,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 9 * scale),
        decoration: BoxDecoration(
          color: filled ? AppColors.brownDark : Colors.transparent,
          borderRadius: BorderRadius.circular(20 * scale),
          border: Border.all(color: AppColors.brownDark, width: 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13 * scale,
            fontWeight: FontWeight.w600,
            color: filled ? AppColors.cream : AppColors.brownDark,
          ),
        ),
      ),
    );
  }

  // --- Filter chips (search icon leads the row) -----------------------------
  Widget _filterChips(double s) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _searchOpen ? _searchBar(s) : _chipsRow(s),
    );
  }

  Widget _searchBar(double s) {
    return Padding(
      key: const ValueKey('search'),
      padding: EdgeInsets.symmetric(horizontal: 22 * s),
      child: Container(
        height: 40 * s,
        decoration: BoxDecoration(
          color: AppColors.chipLight,
          borderRadius: BorderRadius.circular(20 * s),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => setState(() {
                _searchOpen = false;
                _searchController.clear();
              }),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12 * s),
                child: Icon(Icons.arrow_back, size: 18 * s, color: AppColors.brownDark),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search coffee shops...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13 * s,
                    color: AppColors.brownMid,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: GoogleFonts.inter(
                  fontSize: 13 * s,
                  color: AppColors.brownDark,
                ),
              ),
            ),
            SizedBox(width: 12 * s),
          ],
        ),
      ),
    );
  }

  Widget _chipsRow(double s) {
    return SizedBox(
      key: const ValueKey('chips'),
      height: 40 * s,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 22 * s),
        itemCount: HomeScreen.filterLabels.length + 1,
        separatorBuilder: (_, __) => SizedBox(width: 8 * s),
        itemBuilder: (context, i) {
          if (i == 0) {
            return GestureDetector(
              onTap: () => setState(() => _searchOpen = true),
              child: Container(
                width: 40 * s,
                height: 40 * s,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.chipLight,
                  borderRadius: BorderRadius.circular(20 * s),
                ),
                child: Icon(Icons.search, size: 18 * s, color: AppColors.brownDark),
              ),
            );
          }
          final label = HomeScreen.filterLabels[i - 1];
          final active = label == _activeFilter;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = label),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 8 * s),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.brownDark : AppColors.tan.withOpacity(0.67),
                borderRadius: BorderRadius.circular(20 * s),
              ),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13 * s,
                  color: active ? AppColors.cream : AppColors.brownDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Floating pill nav bar -----------------------------------------------
  Widget _bottomNav() {
    return IgnorePointer(
      ignoring: !_navVisible,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        offset: _navVisible ? Offset.zero : const Offset(0, 1.6),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: _navVisible ? 1 : 0,
          child: Container(
            color: Colors.transparent,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.brownDark,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:[
                      _navIcon(Icons.home, active: true, onTap: () {}),
                      _navIcon(Icons.bookmark_border, onTap: () {Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => DiaryPage()),
                        );
                      }),
                      _navIcon(Icons.history, onTap: () {}),
                      _navIcon(Icons.add, onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => Step1PicturePage(state: AddCafeState())),
                      )),
                      _navIcon(Icons.person_outline, onTap: () {Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ProfilePage()),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, {bool active = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.tan : Colors.transparent,
      ),
      child: Icon(
        icon,
        size: 20,
        color: active ? AppColors.brownDark : AppColors.tan.withOpacity(0.6),
      ),
      ),
    );
  }
}