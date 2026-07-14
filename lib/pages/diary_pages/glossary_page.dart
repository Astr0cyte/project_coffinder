import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:project_coffinder/widgets/coffee_glossary_card.dart';
import 'package:project_coffinder/models/coffee_glossary_item.dart';

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
								alignment: Alignment(-0.40, -0.55),
								child: Text(
									"Vietnamese pronunciation of popular coffees",
									style: GoogleFonts.quicksand(
										fontSize: 14,
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
                  heightFactor: 0.7,
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



  