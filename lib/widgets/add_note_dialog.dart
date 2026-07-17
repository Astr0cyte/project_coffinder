import 'package:flutter/material.dart';
import '../models/diary_note.dart';

class AddNoteDialog extends StatefulWidget {
  final DiaryNote? note;

  const AddNoteDialog({
    super.key,
    this.note,
  });

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  late final TextEditingController titleController;
  late final TextEditingController bodyController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.note?.title ?? '',
    );

    bodyController = TextEditingController(
      text: widget.note?.body.replaceFirst('• ', '') ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.note != null;

    return AlertDialog(
      title: Text(editing ? "Edit Note" : "Add Note"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(
                labelText: "Note",
                hintText: "Write your note...",
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.trim().isEmpty ||
                bodyController.text.trim().isEmpty) {
              return;
            }

            Navigator.pop(
              context,
              DiaryNote(
                title: titleController.text.trim(),
                body: bodyController.text
                .trim()
                .split('\n')
                .map((line) => '• $line')
                .join('\n'),
                expanded: widget.note?.expanded ?? false,
              ),
            );
          },
          child: Text(editing ? "Save" : "Add"),
        ),
      ],
    );
  }
}