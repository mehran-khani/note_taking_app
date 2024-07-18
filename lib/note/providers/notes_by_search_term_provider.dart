import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';
import 'package:note_taking_app/note/backend/note_info_storage.dart';
import 'package:note_taking_app/note/model/note_model.dart';
import 'package:note_taking_app/state/auth/provider/user_id_provider.dart';
import 'package:note_taking_app/state/constants/firebase_collection_name.dart';
import 'package:note_taking_app/state/constants/firebase_field_name.dart';

final notesBySearchTermProvider = StreamProvider.family
    .autoDispose<Iterable<Note>, SearchTerm?>((ref, SearchTerm? searchTerm) {
  final userId = ref.watch(userIdProvider);
  NoteInfoStorage noteInfoStorage = const NoteInfoStorage();
  final controller = StreamController<Iterable<Note>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .doc(userId)
      .collection(FirebaseCollectionName.notes)
      .orderBy(FirebaseFieldName.createdAt, descending: true)
      .snapshots()
      .listen(
    (snapshot) async {
      final documents = snapshot.docs;
      // print('$documents');
      final notes = documents.map((doc) async {
        final note = Note.fromSnapshot(doc);
        // Decrypt title and content
        final decryptedTitle =
            await noteInfoStorage.decryptNoteData(note.title, userId!);
        final decryptedContent =
            await noteInfoStorage.decryptNoteData(note.content, userId);
        return note.copyWith(title: decryptedTitle, content: decryptedContent);
      }).toList();

      final decryptedNotes = await Future.wait(notes);
      final searchedNotes = decryptedNotes
          .where(
            (note) =>
                note.title.toLowerCase().contains(searchTerm!.toLowerCase()) ||
                note.content.toLowerCase().contains(searchTerm.toLowerCase()),
          )
          .toList();

      print('notes are : $decryptedNotes');

      controller.sink.add(searchedNotes);
    },
  );

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
});


// final notesBySearchTermProvider = StreamProvider.family
//     .autoDispose<Iterable<Note>, SearchTerm?>((ref, SearchTerm? searchTerm) {
//   final userId = ref.watch(userIdProvider);

//   final contrller = StreamController<Iterable<Note>>();

//   final sub = FirebaseFirestore.instance
//       .collection(FirebaseCollectionName.users)
//       .doc(userId)
//       .collection(FirebaseCollectionName.notes)
//       .orderBy(FirebaseFieldName.createdAt, descending: true)
//       .snapshots()
//       .listen(
//     (snapshot) async {
//       final notes = snapshot.docs.map((doc) => Note.fromSnapshot(doc)).where(
//             (note) =>
//                 note.title.toLowerCase().contains(searchTerm!.toLowerCase()) ||
//                 note.content.toLowerCase().contains(searchTerm.toLowerCase()),
//           );
//       contrller.sink.add(notes);
//     },
//   );

//   ref.onDispose(() {
//     contrller.close();
//     sub.cancel();
//   });

//   return contrller.stream;
// });
