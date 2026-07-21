import 'package:brewstreet_app/app_colors.dart';
import 'package:brewstreet_app/pages/saved_shops.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/diary_note.dart';
import '/widgets/add_note_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/diary_note_card.dart';
import '../../widgets/diary_scaffold.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  static const int _savedShopsTab = 1;

  int selectedTab = 3;

  final List<DiaryNote> notes = [
    DiaryNote(
      title: "Coffee tasting notes",
      body: "• Longer note has a drop down and ellipse\n"
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
      body: "• Ability to attach notes to specific coffee\n"
          "shop items within a specific coffee shop?",
    ),
  ];
  Stream<List<DiaryNote>> loadFirebaseNotes() {
    return FirebaseFirestore.instance
        .collection("notes")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return DiaryNote(
          title: data["notesTitle"] ?? "",
          body: data["notesDescription"] ?? "",
        );
      }).toList();
    });
  }

  final tabs = const [
    "Glossary",
    "Saved Shops",
    "Draft Reviews",
    "Notes",
  ];

  @override
  Widget build(BuildContext context) {
    final bool showingSavedShops = selectedTab == _savedShopsTab;

    return DiaryScaffold(
      tabs: tabs,
      selectedIndex: selectedTab,
      onSelected: (index) {
        setState(() {
          selectedTab = index;
        });
      },
      child: showingSavedShops ? const SavedShops() : _buildNotesTab(),
    );
  }

  Widget _buildNotesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Write your thoughts below",
          style: TextStyle(
            color: AppColors.brownMid,
            fontFamily: GoogleFonts.quicksand().fontFamily,
          ),
        ),
        const Align(
          alignment: Alignment(0, -0.50),
          child: Divider(
            color: AppColors.gold,
            thickness: 1,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<DiaryNote>>(
          stream: loadFirebaseNotes(),
          builder: (context, snapshot) {
            final firebaseNotes = snapshot.data ?? [];

            final allNotes = [
              ...notes,
              ...firebaseNotes,
            ];

            return Column(
              children: allNotes.map((note) {
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
                    onEdit: () async {
                      final DiaryNote? editedNote = await showDialog<DiaryNote>(
                        context: context,
                        builder: (_) => AddNoteDialog(),
                      );

                      if (editedNote != null) {
                        setState(() {
                          note.title = editedNote.title;
                          note.body = editedNote.body;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            );
          },
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
      ],
    );
  }
}
