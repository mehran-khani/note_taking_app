import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/note/backend/note_info_storage.dart';
import 'package:note_taking_app/note/model/note_model.dart';
import 'package:note_taking_app/state/auth/provider/user_id_provider.dart';
import 'package:note_taking_app/state/constants/firebase_collection_name.dart';
import 'package:note_taking_app/state/constants/firebase_field_name.dart';

final userNotesProvider = StreamProvider.autoDispose<Iterable<Note>>((ref) {
  try {
    final userId = ref.watch(userIdProvider);
    // const noteInfoStorage = NoteInfoStorage();
    if (userId == null) {
      // Return an empty stream if the user is logged out
      return Stream.value([]);
    }
    NoteInfoStorage noteInfoStorage = const NoteInfoStorage();
    final controller = StreamController<Iterable<Note>>();

    controller.onListen = () {
      controller.sink.add([]);
    };

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .collection(FirebaseCollectionName.notes)
        .orderBy(FirebaseFieldName.createdAt, descending: true)
        .snapshots()
        .listen((snapshot) async {
      final documents = snapshot.docs;
      print('$documents');
      final notes = documents
          // TODO : we can add this for bigger files that may take longer in the firebase to write the date
          // .where((doc) => !doc.metadata.hasPendingWrites)
          .map((doc) async {
        final note = Note.fromSnapshot(doc);
        // Decrypt title and content
        final decryptedTitle =
            await noteInfoStorage.decryptNoteData(note.title, userId);
        final decryptedContent =
            await noteInfoStorage.decryptNoteData(note.content, userId);
        return note.copyWith(title: decryptedTitle, content: decryptedContent);
      }).toList();

      final decryptedNotes = await Future.wait(notes);

      print('notes are : $decryptedNotes');

      controller.sink.add(decryptedNotes);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  } on FirebaseException catch (e) {
    throw FirebaseException(plugin: '$e');
  }
});



    // final sub = FirebaseFirestore.instance
    //     .collection(FirebaseCollectionName.users)
    //     .doc(userId)
    //     .collection(FirebaseCollectionName.notes)
    //     .orderBy(FirebaseFieldName.createdAt, descending: true)
    //     .snapshots()
    //     .listen((snapshot) {
    //   final documents = snapshot.docs;
    //   print('$documents');
    //   final notes = documents
    //       // .where((doc) => !doc.metadata.hasPendingWrites)
    //       .map((doc) => Note.fromSnapshot(doc))
    //       .toList();

    //   print('notes are : $notes');