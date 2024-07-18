import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/note/model/note_model.dart';
import 'package:note_taking_app/note/providers/note_delete_provider.dart';
import 'package:note_taking_app/state/auth/provider/user_id_provider.dart';
import 'package:note_taking_app/widgets/dialogs/custom_alert_dialog.dart';
import 'package:note_taking_app/widgets/dialogs/delete_dialog.dart';

class NoteCard extends ConsumerWidget {
  final Note note;

  const NoteCard({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    final backgroundColor = Theme.of(context)
        .colorScheme
        .background; // Background color of the main screen

    return GestureDetector(
      onLongPress: () async {
        final shouldDelete = await const DeleteDialog()
            .present(context)
            .then((value) => value ?? false);

        if (shouldDelete) {
          if (userId != null) {
            ref
                .read(noteDelteProvider.notifier)
                .delete(noteId: note.noteId, userId: userId);
          }
        }
      },
      onTap: () {
        GoRouter.of(context).go('/edit', extra: note);
      },
      child: Card(
        elevation: 5, // Add elevation for shadow
        shadowColor: Colors.blue.shade200,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: backgroundColor
                .withOpacity(0.4), // Adjust opacity for glass effect
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2, // Limit title to two lines
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Flexible(
                      child: Text(
                        note.content,
                        style: const TextStyle(fontSize: 14.0),
                        maxLines: 3, // Limit content to three lines
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // IconButton(
              //     icon: Icon(
              //       _isSelected
              //           ? Icons.radio_button_checked
              //           : Icons.radio_button_unchecked,
              //     ),
              //     onPressed: () {
              //       setState(() {
              //         _isSelected = !_isSelected;
              //       });
              //     }),
            ],
          ),
        ),
      ),
    );
  }
}
