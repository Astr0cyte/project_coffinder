import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cafe_model.dart';
import '../services/saved_cafe_service.dart';
import '../widgets/shop_card.dart';
import 'app_colors.dart';
import 'coffee_shop_detail_screen.dart';
import 'home_screen.dart' show ShopListItem;

class SavedShops extends StatefulWidget {
  const SavedShops({super.key});

  @override
  State<SavedShops> createState() => _SavedShopsState();
}

class _SavedShopsState extends State<SavedShops> {
  static const _cardColors = [
    AppColors.brownMid,
    AppColors.cardBg,
    AppColors.brownDark,
    AppColors.tan,
    AppColors.chipLight,
  ];

  List<CafeModel> _cafes = [];
  bool _loading = true;
  StreamSubscription<List<CafeModel>>? _sub;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.isAnonymous) {
      _sub = SavedCafeService.instance.streamSavedCafes(user.uid).listen(
        (cafes) {
          if (mounted) setState(() { _cafes = cafes; _loading = false; });
        },
        onError: (_) { if (mounted) setState(() => _loading = false); },
      );
    } else {
      _loading = false;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;

    if (isGuest) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          'Sign in to save your favourite coffee shops.',
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.brownMid),
        ),
      );
    }

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_cafes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          'No saved shops yet. Tap the heart on a shop to save it here.',
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.brownMid),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cafes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        final cafe = _cafes[i];
        return ShopCard(
          shop: ShopListItem(
            cafe.cafeName,
            _cardColors[i % _cardColors.length],
            true,
            cafe.area,
            cafe.features,
            imageUrl: cafe.imageUrl,
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CoffeeShopDetailScreen(cafe: cafe),
            ),
          ),
        );
      },
    );
  }
}
