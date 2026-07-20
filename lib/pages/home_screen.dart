
import 'package:brewstreet_app/models/cafe.dart';
import 'package:brewstreet_app/services/cafe_services.dart';
import 'package:brewstreet_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'coffee_shop_detail_screen.dart';
import '../widgets/shop_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});



  static const filterLabels = ['All', 'Quiet', 'Wi-Fi', 'A/C', 'Pets', 'Friendly'];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double designWidth = 402;

  bool _navVisible = true;
  double _lastOffset = 0;
  String _activeFilter = 'All';
  bool _searchOpen = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      extendBody: true,
      bottomNavigationBar: BottomNav(
        context: context,
        navVisible: _navVisible,
      ),
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
                 SliverToBoxAdapter(
    child: _filterChips(scale),
  ),
                SliverToBoxAdapter(
  child: Padding(
    padding: EdgeInsets.fromLTRB(
      20 * scale,
      12 * scale,
      20 * scale,
      0,
    ),
    child: StreamBuilder<List<Cafe>>(
      stream: CafeService().getCafes(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        final cafes = snapshot.data ?? [];
        List<Cafe> filteredCafes = cafes;

        if (_searchController.text.isNotEmpty) {
        filteredCafes = filteredCafes.where((cafe) {
          return cafe.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
        }).toList();
      }

      if (_activeFilter != "All") {
      filteredCafes = filteredCafes.where((cafe) {
        return cafe.tags.contains(_activeFilter);
      }).toList();
    }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredCafes.length,
          separatorBuilder: (_, __) => SizedBox(height: 14 * scale),
          itemBuilder: (context, i) {

            final cafe = filteredCafes[i];

            return ShopCard(
              shopName: cafe.name,
              imageUrl: cafe.imageUrl,
              rating: cafe.averageRating,
              tags: cafe.tags,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoffeeShopDetailScreen(
                      cafeId: cafe.id,
                      shopName: cafe.name, address: '',
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
),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20 * scale, 16 * scale, 20 * scale, 110 * scale),
                    child: Text(
                      child: Text(
                        "${filteredCafes.length} Coffee Shops Found",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13 * scale,
                          color: AppColors.brownMid,
                        ),
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 13 * scale,
                        color: AppColors.brownMid,
                      ),
                    ),
                  ),
                ),
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
    const userName = 'Ashneil Dass';
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
                      userName,
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
                color: active ? AppColors.brownDark : AppColors.tan.withOpacity(0.57),
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