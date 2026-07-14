import 'package:flutter/material.dart';

class AddNoteDialog extends StatelessWidget {
  const AddNoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Note'),
      content: const TextField(
        decoration: InputDecoration(
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
            // notes shall be saved into firebase - to be done later
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}