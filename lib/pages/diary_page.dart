import '../model/diary_note.dart';
import 'package:brewstreet_app/widgets/add_note_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/diary_note_card.dart';
import '../widgets/diary_top_row.dart';


class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  int selectedTab = 3;

final List<DiaryNote> notes = [
  DiaryNote(
    title: "Coffee tasting notes",
    body:
        "• Longer note has a drop down and ellipse\n"
        "to demonstrate a note is longer than the\n"
        "\"preview\" card.\n"
        "• Arabica beans.\n"
        "• Toffee praline flavours. Earthy richness.",
    expanded: true,
  ),
  DiaryNote(
    title: "Shorter note",
    body: "• No drop-down required for short notes.",
  ),
  DiaryNote(
    title: "Coffee tasting notes",
    body:
        "• Ability to attach notes to specific coffee\n"
        "shop items within a specific coffee shop?",
  ),
];
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
                color: Color(0xff402f11),
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

           Column(
            children: notes.map((note) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: DiaryNoteCard(
                  title: note.title,
                  body: note.body,
                  expanded: note.expanded,
                  onToggle: () {
                    setState(() {
                      note.expanded = !note.expanded;
                    });
                  },
                ),
              );
            }).toList(),
          ),

            const SizedBox(height: 22),

            GestureDetector(
            onTap: () async {
            final DiaryNote? newNote = await showDialog<DiaryNote>(
              context: context,
              builder: (context) => const AddNoteDialog(),
            );

            if (newNote != null) {
              setState(() {
                notes.add(newNote);
              });
            }
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