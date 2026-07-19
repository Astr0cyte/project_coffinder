import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/app_colors.dart';

/// Reusable coffee-shop card, used by HomeScreen's shop list and by
/// SavedShops (the Diary page's "Saved Shops" tab).
class ShopCard extends StatelessWidget {
  final String shopName;
  final String imageUrl;
  final double rating;
  final List<String> tags;
  final double scale;
  final VoidCallback? onTap;

  const ShopCard({
    super.key,
    required this.shopName,
    required this.imageUrl,
    required this.rating,
    required this.tags,
    this.scale = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;
    final contentColor = AppColors.brownDark;
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
            Container(color: AppColors.cream),
            Positioned(
              right: 10 * s,
              top: 10 * s,
              child: Container(
                width: 27 * s,
                height: 27 * s,
                decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                child: Icon(
                  Icons.favorite,
                  size: 15 * s,
                  color: AppColors.brownDark,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: isDarkCard
                    ? Colors.black.withOpacity(0.16)
                    : AppColors.brownDark.withOpacity(0.06),
                padding: EdgeInsets.fromLTRB(14 * s, 10 * s, 14 * s, 10 * s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: shopName,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 23 * s,
                            fontWeight: FontWeight.w600,
                            color: contentColor,
                          ),
                        ),
                        TextSpan(
                          text: ' ${rating.toStringAsFixed(1)} ★',
                          style: GoogleFonts.inter(
                            fontSize: 12 * s,
                            color: contentColor.withOpacity(0.75),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(height: 6 * s),
                    Wrap(
                      spacing: 6 * s,
                      runSpacing: 6 * s,
                      children: tags
                          .map((label) => Container(
                                padding: EdgeInsets.symmetric(horizontal: 9 * s, vertical: 4 * s),
                                decoration: BoxDecoration(
                                  color: contentColor.withOpacity(isDarkCard ? 0.2 : 0.1),
                                  borderRadius: BorderRadius.circular(10 * s),
                                ),
                                child: Text(
                                  label,
                                  style: GoogleFonts.inter(fontSize: 10 * s, color: contentColor),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}