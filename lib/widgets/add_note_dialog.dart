import 'package:flutter/material.dart';
import '../model/diary_note.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {

  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Note'),
      content: TextField(
      controller: noteController,
        decoration: const InputDecoration(
          hintText: 'Write your note...',
        ),
        maxLines: 5,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if(noteController.text.trim().isEmpty) return;

            Navigator.pop(
              context,
              DiaryNote(
                title: "New Note",
                body: "• ${noteController.text.trim()}",
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}