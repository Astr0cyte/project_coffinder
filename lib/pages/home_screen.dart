import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'coffee_shop_detail_screen.dart';
import '../widgets/shop_card.dart';

class ShopListItem {
  final String name;
  final Color bgColor;
  final bool favorited;
  final String distance;
  final List<String> amenities;
  const ShopListItem(this.name, this.bgColor, this.favorited, this.distance, this.amenities);

  /// Text/icon color that stays readable against [bgColor].
  Color contentColor(BuildContext context) {
    final brightness = ThemeData.estimateBrightnessForColor(bgColor);
    return brightness == Brightness.dark ? AppColors.cream : AppColors.brownDark;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const shops = [
    ShopListItem('Phuc Long', AppColors.brownMid, false, '350 m away', ['A/C', 'Wi-Fi', 'Quiet']),
    ShopListItem('Lotus Leaf Cafe', AppColors.cardBg, false, '0.8 km away', ['Pets', 'Friendly']),
    ShopListItem('Sunset Terrace Coffee', AppColors.brownDark, true, '1.2 km away', ['Quiet', 'Wi-Fi']),
    ShopListItem('Ban Mai Coffee House', AppColors.tan, true, '1.5 km away', ['A/C', 'Friendly']),
    ShopListItem('Old Quarter Coffee', AppColors.chipLight, false, '2.0 km away', ['Pets', 'Wi-Fi', 'Quiet']),
  ];

  static const filterLabels = ['All', 'Quiet', 'Wi-Fi', 'A/C', 'Pets', 'Friendly'];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double designWidth = 402;

  String _activeFilter = 'All';
  bool _searchOpen = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ShopListItem> get _visibleShops {
    if (_activeFilter == 'All') return HomeScreen.shops;
    return HomeScreen.shops.where((s) => s.amenities.contains(_activeFilter)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      // Đã xóa extendBody và bottomNavigationBar ở đây
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = constraints.maxWidth / designWidth;
            // Đã xóa NotificationListener vì MainScreen sẽ tự động bắt được sự kiện cuộn
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(context, scale)),
                SliverToBoxAdapter(child: _filterChips(scale)),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(20 * scale, 12 * scale, 20 * scale, 0),
                  sliver: SliverList.separated(
                    itemCount: _visibleShops.length,
                    separatorBuilder: (_, __) => SizedBox(height: 14 * scale),
                    itemBuilder: (context, i) => ShopCard(
                      shop: _visibleShops[i],
                      scale: scale,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CoffeeShopDetailScreen(shopName: _visibleShops[i].name),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    // Lớp padding đáy (110 * scale) vẫn được giữ nguyên để
                    // danh sách cuộn lên trên không bị cái Navbar của MainScreen che khuất
                    padding: EdgeInsets.fromLTRB(20 * scale, 16 * scale, 20 * scale, 110 * scale),
                    child: Text(
                      '${_visibleShops.length} Coffeeshops Found',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13 * scale,
                        color: AppColors.brownMid,
                      ),
                    ),
                  ),
                ),
              ],
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
}