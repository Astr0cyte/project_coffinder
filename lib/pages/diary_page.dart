import '/widgets/add_note_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/diary_note_card.dart';
import '../widgets/diary_scaffold.dart';
import 'saved_shops.dart';
import 'diary_pages/glossary_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/diary_note_model.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();


}


class _DiaryPageState extends State<DiaryPage> {

    @override
  void initState() {
  super.initState();
  loadNotes();
}

Future<void> loadNotes() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final snapshot = await FirebaseFirestore.instance
      .collection('diaries')
      .where('user_id', isEqualTo: uid)
      .get();

  setState(() {
    notes = snapshot.docs
        .map((doc) => DiaryNoteModel.fromFirestore(doc.data()))
        .toList();
  });
}
  static const int _glossaryTab = 0;
  static const int _savedShopsTab = 1;

  int selectedTab = 2;

  List<DiaryNoteModel> notes = [];

  final tabs = const [
    "Glossary",
    "Saved Shops",
    "Notes",
  ];

  @override
  Widget build(BuildContext context) {
    return DiaryScaffold(
      tabs: tabs,
      selectedIndex: selectedTab,
      onSelected: (index) {
        setState(() {
          selectedTab = index;
        });
      },
      child: selectedTab == _glossaryTab
          ? const DiaryGlossaryPage()
          : selectedTab == _savedShopsTab
              ? const SavedShops()
              : _buildNotesTab(),
    );
  }

  Widget _buildNotesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            final DiaryNoteModel? newNote = await showDialog<DiaryNoteModel>(
              context: context,
              builder: (context) => const AddNoteDialog(),
            );

            if (newNote != null) {
            await FirebaseFirestore.instance
                .collection('diaries')
                .add(newNote.toFirestore());

            await loadNotes();
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
      ],
    );
  }
}