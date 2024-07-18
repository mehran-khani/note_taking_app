import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/note/providers/user_notes_provider.dart';
import 'package:note_taking_app/views/animations/empty_animation.dart';
import 'package:note_taking_app/views/animations/error_animation.dart';
import 'package:note_taking_app/views/animations/loading_animation.dart';
import 'package:note_taking_app/views/notes/widgets/notes_grid_view.dart';

class Notes extends ConsumerWidget {
  const Notes({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(userNotesProvider);

    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userNotesProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: notes.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const EmptyAnimationView();
          } else {
            return NotesGridView(notes: notes);
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }

  // return StreamBuilder<QuerySnapshot>(
  //     stream: _fetchNotesStream(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       }

  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const CircularProgressIndicator();
  //       }

  //       final notes = snapshot.data?.docs.map((doc) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         return Note(
  //           title: data['title'] ?? '',
  //           content: data['content'] ?? '',
  //           noteId: data['note_id'] ?? '',
  //           createdAt: data[''] ?? '',
  //           updatedAt: data[''] ?? '',
  //         );
  //       }).toList();

  //       return ListView.builder(
  //         itemCount: notes?.length ?? 0,
  //         itemBuilder: (context, index) {
  //           final note = notes![index];
  //           return ListTile(
  //             title: Text(note.title),
  //             subtitle: Text(note.content),
  //             onTap: () {
  //               // Handle tap event here, e.g., navigate to note details screen
  //               Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (context) => NoteDetailsScreen(note: note),
  //               ));
  //             },
  //             onLongPress: () {
  //               _showDeleteConfirmationDialog(context, note);
  //             },
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Future<void> _showDeleteConfirmationDialog(
  //     BuildContext context, Note note) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Delete Note'),
  //         content: const SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Are you sure you want to delete this note?'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Delete'),
  //             onPressed: () {
  //               const NoteInfoStorage()
  //                   .deleteNote(userId: userId!, noteId: note.noteId);
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

// class NoteDetailsScreen extends StatelessWidget {
//   final Note note;

//   const NoteDetailsScreen({
//     super.key,
//     required this.note,
//   });2

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Note Details'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(note.title),
//             Text(note.content),
//           ],
//         ),
//       ),
//     );
//   }
// }

