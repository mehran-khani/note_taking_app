import 'package:flutter/material.dart';
import 'package:note_taking_app/note/model/note_model.dart';
import 'package:note_taking_app/views/notes/widgets/note_card.dart';

class NotesGridView extends StatelessWidget {
  const NotesGridView({
    super.key,
    required this.notes,
  });

  final Iterable<Note> notes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // Adjust the number of items per row here
        childAspectRatio: 3, // Adjust the aspect ratio to control item height
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return NoteCard(
          note: note,
        );
      },
    );
  }
}
