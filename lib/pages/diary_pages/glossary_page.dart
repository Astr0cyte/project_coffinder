import 'package:brewstreet_app/models/coffee_glossary_item.dart';
import 'package:brewstreet_app/widgets/coffee_glossary_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DiaryGlossaryPage extends StatefulWidget {
  DiaryGlossaryPage({super.key});

@override
  State<DiaryGlossaryPage> createState() => _DiaryGlossaryPageState();
}

class _DiaryGlossaryPageState extends State<DiaryGlossaryPage> {

  Future<List<CoffeeGlossaryItem>> loadCoffeeData() async {
    // Read raw text from file
    final String jsonString = await rootBundle.loadString('assets/data/coffees.json');
    
    // Text -> Dart List
    final List<dynamic> jsonList = json.decode(jsonString);
    
    // Utilise factory within Data Model file
    return jsonList.map((json) => CoffeeGlossaryItem.fromJson(json)).toList();
  }

Stream<List<CoffeeGlossaryItem>> loadFirebaseCoffeeData() {
  return FirebaseFirestore.instance
      .collection("coffee_glossary")
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return CoffeeGlossaryItem.fromFirestore(doc.data());
    }).toList();
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(250, 249, 244, 1.0),
          ), 

          child: Stack(
						children: [
							// 1 - Navigation bar instance

							// 2 - Descriptive phrase
							Align(
								alignment: Alignment(-0.18, -0.55),
								child: Text(
									"Vietnamese pronunciation of popular coffees",
									style: GoogleFonts.quicksand(
										fontSize: 16,
										color: Color.fromRGBO(126, 101, 76, 1.0),
									),
								),
							),

							// 3 - Divider line
							Align(
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
                  builder: (context, jsonSnapshot) {

                    if (jsonSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final jsonItems = jsonSnapshot.data ?? [];

                    return StreamBuilder<List<CoffeeGlossaryItem>>(
                      stream: loadFirebaseCoffeeData(),
                      builder: (context, firebaseSnapshot) {

                        final firebaseItems = firebaseSnapshot.data ?? [];

                        final allItems = [
                          ...jsonItems,
                          ...firebaseItems,
                        ];

                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 16),
                          itemCount: allItems.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CoffeeGlossaryCard(
                                coffee: allItems[index],
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
            ],
          ),
        ),
                );
              }
}
  
