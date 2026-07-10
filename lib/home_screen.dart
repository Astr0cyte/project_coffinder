import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'coffee_shop_detail_screen.dart';

class ShopListItem {
  final String name;
  final Color bgColor;
  final bool favorited;
  final String distance;
  const ShopListItem(this.name, this.bgColor, this.favorited, this.distance);

  /// Text/icon color that stays readable against [bgColor].
  Color contentColor(BuildContext context) {
    final brightness = ThemeData.estimateBrightnessForColor(bgColor);
    return brightness == Brightness.dark ? AppColors.cream : AppColors.brownDark;
  }
}

class FilterChipData {
  final String label;
  final bool active;
  const FilterChipData(this.label, this.active);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double designWidth = 402;

  static const shops = [
    ShopListItem('Phuc Long', AppColors.brownMid, false, '350 m away'),
    ShopListItem('Lotus Leaf Cafe', AppColors.cardBg, false, '0.8 km away'),
    ShopListItem('Sunset Terrace Coffee', AppColors.brownDark, true, '1.2 km away'),
    ShopListItem('Ban Mai Coffee House', AppColors.tan, true, '1.5 km away'),
    ShopListItem('Old Quarter Coffee', AppColors.chipLight, false, '2.0 km away'),
    ShopListItem('Old Quarter Coffee', AppColors.chipLight, false, '2.0 km away'),
    ShopListItem('Old Quarter Coffee', AppColors.chipLight, false, '2.0 km away'),
  ];


  static const filters = [
    FilterChipData('All', false),
    FilterChipData('Quiet', true),
    FilterChipData('Wi-Fi', false),
    FilterChipData('A/C', false),
    FilterChipData('Pets', false),
    FilterChipData('Friendly', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = constraints.maxWidth / designWidth;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(scale)),
                SliverToBoxAdapter(child: _resultsLabel(scale)),
                SliverToBoxAdapter(child: _filterChips(scale)),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(20 * scale, 12 * scale, 20 * scale, 20 * scale),
                  sliver: SliverList.separated(
                    itemCount: shops.length,
                    separatorBuilder: (_, __) => SizedBox(height: 14 * scale),
                    itemBuilder: (context, i) => _shopCard(context, scale, shops[i]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- Header: city + brand title -----------------------------------------
  Widget _header(double s) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22 * s, 16 * s, 22 * s, 4 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hồ Chí Minh City',
            style: GoogleFonts.inter(fontSize: 14 * s, color: AppColors.brownDark),
          ),
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

  // --- "Coffee shops nearby" ------------------------------------------------
  Widget _resultsLabel(double s) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22 * s, 16 * s, 22 * s, 12 * s),
      child: Text(
        '${shops.length} Coffee shops nearby',
        style: GoogleFonts.playfairDisplay(
          fontSize: 20 * s,
          fontWeight: FontWeight.w600,
          color: AppColors.brownDark,
        ),
      ),
    );
  }

  // --- Filter chips (search icon leads the row) -----------------------------
  Widget _filterChips(double s) {
    return SizedBox(
      height: 40 * s,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 22 * s),
        itemCount: filters.length + 1,
        separatorBuilder: (_, __) => SizedBox(width: 8 * s),
        itemBuilder: (context, i) {
          if (i == 0) {
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search tapped')),
                );
              },
              child: Container(
                width: 40 * s,
                height: 40 * s,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.brownDark,
                  borderRadius: BorderRadius.circular(20 * s),
                ),
                child: Icon(Icons.search, size: 18 * s, color: AppColors.tan),
              ),
            );
          }
          final f = filters[i - 1];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 8 * s),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: f.active ? AppColors.brownDark : AppColors.tan.withOpacity(0.57),
              borderRadius: BorderRadius.circular(20 * s),
            ),
            child: Text(
              f.label,
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                color: f.active ? AppColors.cream : AppColors.brownDark,
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Shop card --------------------------------------------------------------
  Widget _shopCard(BuildContext context, double s, ShopListItem shop) {
    final contentColor = shop.contentColor(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CoffeeShopDetailScreen(shopName: shop.name),
          ),
        );
      },
      child: Container(
        // Raised from the original 78 so each card has more presence in the list.
        height: 100 * s,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20 * s),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4 * s,
              offset: Offset(0, 4 * s),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: shop.bgColor),
            Positioned(
              left: 16 * s,
              bottom: 14 * s,
              right: 50 * s,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      shop.name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16 * s,
                        fontWeight: FontWeight.w600,
                        color: contentColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 8 * s),
                  Text(
                    shop.distance,
                    style: GoogleFonts.inter(
                      fontSize: 11 * s,
                      color: contentColor.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10 * s,
              top: 10 * s,
              child: Container(
                width: 27 * s,
                height: 27 * s,
                decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                child: Icon(
                  shop.favorited ? Icons.favorite : Icons.favorite_border,
                  size: 15 * s,
                  color: AppColors.brownDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Floating pill nav bar -----------------------------------------------
  Widget _bottomNav() {
    return SafeArea(
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
            children: [
              _navIcon(Icons.home, active: true),
              _navIcon(Icons.bookmark_border),
              _navIcon(Icons.history),
              _navIcon(Icons.notifications_none),
              _navIcon(Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, {bool active = false}) {
    return Container(
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
    );
  }
}
