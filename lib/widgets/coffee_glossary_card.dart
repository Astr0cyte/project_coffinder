import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_coffinder/models/coffee_glossary_item.dart';

class CoffeeGlossaryCard extends StatefulWidget {
  final CoffeeGlossaryItem coffee;

  CoffeeGlossaryCard({super.key, required this.coffee});

  @override
  State<CoffeeGlossaryCard> createState() => _CoffeeGlossaryCardState();
}

class _CoffeeGlossaryCardState extends State<CoffeeGlossaryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, -0.35),
      child: Container(
        width: 348,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Color.fromRGBO(250, 249, 239, 1.0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color.fromRGBO(222, 212, 186, 1.0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              color: Color.fromRGBO(204, 203, 199, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),

        child: AnimatedSize(
          duration: Duration(milliseconds: 300),
          alignment: Alignment.topCenter,
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },

                // Retracted section
                child: Container(
                  height: 96,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          widget.coffee.imagePath,
                          width: 75,
                          height: 75,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.coffee.englishName,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7E654C),
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Image.asset(
                          'assets/arrow_down.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded section
              if (_isExpanded == true)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(222, 212, 186, 1.0),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vietnamese name
                      Text(
                        widget.coffee.vietName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          color: Color(0xFF402F11),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Coloured inner box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F5E8),
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // Adjust this number for more or less rounding
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pronunciation
                            Text(
                              widget.coffee.pronunciation,
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Color(0xFF402F11),
                              ),
                            ),
                            
                            const SizedBox(height: 8),

                            // Description
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F2E1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.coffee.description,
                                    style: GoogleFonts.quicksand(
                                      fontSize: 12,
                                      color: Color(0xFF402F11),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}