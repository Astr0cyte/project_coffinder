import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'diary_top_row.dart';

/// Shared page chrome for the Diary section: back button, "Diary" title,
/// and the tab row. Its only job is switching between tabs and displaying
/// whatever content the caller supplies for the currently selected tab.
class DiaryScaffold extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  const DiaryScaffold({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5EF),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F5EF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Diary",
              style: TextStyle(
                fontSize: 34,
                fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                fontWeight: FontWeight.w600,
                color: const Color(0xff402f11),
              ),
            ),

            const SizedBox(height: 20),

            DiaryTopRow(
              tabs: tabs,
              selectedIndex: selectedIndex,
              onSelected: onSelected,
            ),

            const SizedBox(height: 25),

            child,

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}