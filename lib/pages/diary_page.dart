import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_coffinder/widgets/add_note_dialog.dart';
import '../widgets/diary_note_card.dart';
import '../widgets/diary_top_row.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  int selectedTab = 3;

  final tabs = const [
    "Glossary",
    "Saved Shops",
    "Draft Reviews",
    "Notes",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5EF),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F5EF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Diary",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w500,
                fontFamily: "Serif",
              ),
            ),

            const SizedBox(height: 20),

            DiaryTopRow(
              tabs: tabs,
              selectedIndex: selectedTab,
              onSelected: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
            ),

            const SizedBox(height: 25),

            Text(
              "Write your thoughts below",
              style: TextStyle(
                color: Colors.grey,
                fontFamily: GoogleFonts.quicksand().fontFamily,
              ),
            ),

            const SizedBox(height: 18),

            DiaryNoteCard(
              title: "Coffee tasting notes",
              expanded: true,
              body:
                  "• Longer note has a drop down and ellipse\n"
                  "to demonstrate a note is longer than the\n"
                  "\"preview\" card.\n"
                  "• Arabica beans.\n"
                  "• Toffee praline flavours. Earthy richness.",
              onToggle: () {},
            ),

            const SizedBox(height: 15),

            DiaryNoteCard(
              title: "Shorter note",
              expanded: false,
              body: "• No drop-down required for short notes.",
              onToggle: () {},
            ),

            const SizedBox(height: 15),

            DiaryNoteCard(
              title: "Coffee tasting notes",
              expanded: false,
              body:
                  "• Ability to attach notes to specific coffee\n"
                  "shop items within a specific coffee shop?",
              onToggle: () {},
            ),

            const SizedBox(height: 22),

            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddNoteDialog(),
                );
              },
              child: Text(
                "+ Add a note",
                style: TextStyle(
                  color: Color(0xff8A6A4A),
                  fontSize: 16,
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}