import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../pages/app_colors.dart';
import '/widgets/coffee_glossary_card.dart';
import '/models/coffee_glossary_item.dart';

class DiaryGlossaryPage extends StatefulWidget {
  const DiaryGlossaryPage({super.key});

  @override
  State<DiaryGlossaryPage> createState() => _DiaryGlossaryPageState();
}

class _DiaryGlossaryPageState extends State<DiaryGlossaryPage> {
  Future<List<CoffeeGlossaryItem>> loadCoffeeData() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/coffees.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => CoffeeGlossaryItem.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vietnamese pronunciation of popular coffees',
            style: GoogleFonts.quicksand(
              color: AppColors.brownMid,
            ),
          ),
          const Align(
            alignment: Alignment(0, -0.50),
            child: Divider(
              color: AppColors.gold,
              thickness: 1,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FutureBuilder<List<CoffeeGlossaryItem>>(
              future: loadCoffeeData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final coffeeGlossaryList = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: coffeeGlossaryList.length,
                  itemBuilder: (context, idx) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: CoffeeGlossaryCard(
                            coffee: coffeeGlossaryList[idx],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
