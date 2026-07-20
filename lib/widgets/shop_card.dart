import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/app_colors.dart';
import '../pages/home_screen.dart' show ShopListItem;

/// Reusable coffee-shop card, used by HomeScreen's shop list and by
/// SavedShops (the Diary page's "Saved Shops" tab).
class ShopCard extends StatelessWidget {
  final ShopListItem shop;
  final double scale;
  final VoidCallback? onTap;

  const ShopCard({
    super.key,
    required this.shop,
    this.scale = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;
    final contentColor = shop.contentColor(context);
    final isDarkCard = contentColor == AppColors.cream;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 300 * s,
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
            shop.imageUrl.isNotEmpty
                ? Image.network(
                    shop.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Container(color: shop.bgColor),
                  )
                : Container(color: shop.bgColor),
            Positioned(
              right: 10 * s,
              top: 10 * s,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 4 * s),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(12 * s),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 11 * s, color: AppColors.brownDark),
                    SizedBox(width: 3 * s),
                    Text(
                      shop.rating > 0
                          ? shop.rating.toStringAsFixed(1)
                          : 'New',
                      style: GoogleFonts.inter(
                        fontSize: 11 * s,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brownDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                    padding: EdgeInsets.fromLTRB(14 * s, 10 * s, 14 * s, 10 * s),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: shop.name,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 23 * s,
                                fontWeight: FontWeight.w600,
                                color: AppColors.cream,
                              ),
                            ),
                            TextSpan(
                              text: '  ·  ${shop.distance}',
                              style: GoogleFonts.inter(
                                fontSize: 12 * s,
                                color: AppColors.cream.withOpacity(0.75),
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(height: 6 * s),
                        Wrap(
                          spacing: 6 * s,
                          runSpacing: 6 * s,
                          children: shop.amenities
                              .map((label) => Container(
                                    padding: EdgeInsets.symmetric(horizontal: 9 * s, vertical: 4 * s),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10 * s),
                                    ),
                                    child: Text(
                                      label,
                                      style: GoogleFonts.inter(fontSize: 10 * s, color: AppColors.cream),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}