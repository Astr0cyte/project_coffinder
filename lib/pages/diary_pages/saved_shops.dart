import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_screen.dart';
import '../coffee_shop_detail_screen.dart';
import '../../widgets/shop_card.dart';

/// Shown inside DiaryPage when the "Saved Shops" tab is selected.
/// Renders the user's favorited coffee shops as a list of ShopCards.
class SavedShops extends StatelessWidget {
  const SavedShops({super.key});

  List<ShopListItem> get _savedShops =>
      HomeScreen.shops.where((shop) => shop.favorited).toList();

  @override
  Widget build(BuildContext context) {
    final shops = _savedShops;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your saved coffee shops",
          style: TextStyle(
            color: Color(0xFF7E654C),
            fontFamily: GoogleFonts.quicksand().fontFamily,
          ),
        ),

        const Align(
								alignment: Alignment(0, -0.50),
								child: Divider(
									color: Color.fromRGBO(228, 225, 208, 1),
									thickness: 1, 
								),
							),
        
        const SizedBox(height: 18),

        if (shops.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "No saved shops yet. Tap the heart on a shop to save it here.",
              style: TextStyle(
                color: Color(0xFF7E654C),
                fontFamily: GoogleFonts.quicksand().fontFamily,
              ),
            ),
          )
        else
          Column(
            children: shops.map((shop) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ShopCard(
                  shop: shop,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CoffeeShopDetailScreen(shopName: shop.name),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}