import 'package:brewstreet_app/pages/saved_shops.dart';
import 'package:brewstreet_app/widgets/diary_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '/widgets/coffee_glossary_card.dart';
import '/models/coffee_glossary_item.dart';

class DiaryGlossaryPage extends StatefulWidget {
  const DiaryGlossaryPage({super.key});

@override
  State<DiaryGlossaryPage> createState() => _DiaryGlossaryPageState();
}

class _DiaryGlossaryPageState extends State<DiaryGlossaryPage> {

  late int selectedTab;
  final int _glossaryTab = 0;
  final int _savedShopsTab = 1;
  final int _draftReviewsTab = 2;
  final int _notesTab = 3;

  @override
  void initState() {
    super.initState();
    selectedTab = _glossaryTab;
  }

  Future<List<CoffeeGlossaryItem>> loadCoffeeData() async {
    // Read raw text from file
    final String jsonString = await rootBundle.loadString('assets/data/coffees.json');
    
    // Text -> Dart List
    final List<dynamic> jsonList = json.decode(jsonString);
    
    // Utilise factory within Data Model file
    return jsonList.map((json) => CoffeeGlossaryItem.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    
      // 1 - Navigation bar instance
      const tabs = [
        "Glossary",
        "Saved Shops",
        "Draft Reviews",
        "Notes",
      ];
    
    final bool showingSavedShops = selectedTab == _savedShopsTab;

    return DiaryScaffold(
      tabs: tabs,
      selectedIndex: selectedTab,
      onSelected: (index) {
        setState(() {
          selectedTab = index;
        });
      },
      child: showingSavedShops ? const SavedShops() : buildGlossaryTab(),
    );
  }

  Widget buildGlossaryTab() {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(250, 249, 244, 1.0),
          ), 

          child: Stack(
						children: [

							// 2 - Descriptive phrase
							Align(
								alignment: const Alignment(-0.18, -0.55),
								child: Text(
									"Vietnamese pronunciation of popular coffees",
									style: GoogleFonts.quicksand(
										fontSize: 16,
										color: const Color.fromRGBO(126, 101, 76, 1.0),
									),
								),
							),

							// 3 - Divider line
							const Align(
								alignment: Alignment(0, -0.50),
								child: Divider(
									color: Color.fromRGBO(239, 236, 220, 1.0),
									thickness: 1, 
									indent: 30,
									endIndent: 30,
								),
							),

							// 4 - Coffee definition card instance
							Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.73,
                  child: FutureBuilder<List<CoffeeGlossaryItem>>(
                    future: loadCoffeeData(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final coffeeGlossaryList = snapshot.data!;

                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 16),
                        itemCount: coffeeGlossaryList.length,
                        itemBuilder: (context, idx) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CoffeeGlossaryCard(coffee: coffeeGlossaryList[idx]),
                          );
                        }
                      );
                    }
                  )
                ),
              ),
        		],
          ),
        ),
      );
  }
}



  