class EmailValidator {
  bool isEmailValid(String email) {
    // Regular expression for email validation
    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$', caseSensitive: false);
    return emailRegex.hasMatch(email);
  }
}


// //Code dump:
// // a function for getting the note document id:
// Future<void> getDocumentId() async {
//   try {
//     // Query the collection and get the first document
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection(FirebaseCollectionName.users)
//         .limit(1)
//         .get();

//     // Check if any documents are returned
//     if (snapshot.docs.isNotEmpty) {
//       // Access the document ID of the first document
//       String documentId = snapshot.docs[0].id;
//       print('Document ID: $documentId');
//     } else {
//       print('No documents found');
//     }
//   } catch (e) {
//     print('Error getting document ID: $e');
//   }
// }



//   /// Function to create or update a note for a user.
//   Future<bool> saveAndUpdateNote({
//     required String userId,
//     required String title,
//     required String content,
//   }) async {
//     try {
//       final userNoteRef = FirebaseFirestore.instance
//           .collection(FirebaseCollectionName.users)
//           .doc(userId)
//           .collection(FirebaseCollectionName.notes)
//           .doc();

//       await userNoteRef.set({
//         FirebaseFieldName.title: title,
//         FirebaseFieldName.content: content,
//         FirebaseFieldName.createdAt: Timestamp.now(),
//         FirebaseFieldName.updatedAt: Timestamp.now(),
//       }, SetOptions(merge: true));

//       return true;
//     } catch (e) {
//       print('Error saving or updating note: $e');
//       return false;
//     }
//   }

// single function for creating and updating notes
  // Future<bool> saveAndUpdateNote({
  //   required String title,
  //   required String content,
  //   required UserId userId,
  // }) async {
  //   try {
  //     // first we check if we have the same note from before
  //     final noteInfo = await FirebaseFirestore.instance
  //         .collection(FirebaseCollectionName.users)
  //         .doc(userId)
  //         .collection(FirebaseCollectionName.notes)
  //         .limit(1)
  //         .get();

  //     if (noteInfo.docs.isNotEmpty) {
  //       //we already have this user's info
  //       await noteInfo.docs.first.reference.update({
  //         FirebaseFieldName.content: content,
  //         FirebaseFieldName.title: title,
  //       });
  //       return true;
  //     }

  //     //we don't have this note from beofre. create a new user
  //     final notePayload = Note(title: title, content: content);

  //     await FirebaseFirestore.instance
  //         .collection(FirebaseCollectionName.users)
  //         .add(
  //           notePayload.toJson(),
  //         );
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }



//   import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:note_taking_app/note/model/note_model.dart';
// import 'package:note_taking_app/note/backend/note_info_storage.dart';
// import 'package:note_taking_app/state/auth/type_def/type_def.dart';

// class NoteInfoState extends StateNotifier<List<Note>> {
//   NoteInfoState() : super([]);

//   final _noteInfoStorage = const NoteInfoStorage();

//   Future<void> addNote({
//     required String userId,
//     required Note note,
//   }) async {
//     try {
//       await _noteInfoStorage.addNote(
//         userId: userId,
//         note: note,
//       );
//       state = [...state, note];
//     } catch (e) {
//       // Handle error
//       print('Error adding note: $e');
//     }
//   }

//   Future<void> updateNote({
//     required String userId,
//     required String noteId,
//     required Note updatedNote,
//   }) async {
//     try {
//       await _noteInfoStorage.updateNote(
//         userId: userId,
//         noteId: noteId,
//         updatedNote: updatedNote,
//       );
//       state = state
//           .map((note) => note.noteId == updatedNote.noteId ? updatedNote : note)
//           .toList();
//     } catch (e) {
//       // Handle error
//       print('Error updating note: $e');
//     }
//   }

//   Future<void> deleteNote({
//     required String userId,
//     required String noteId,
//   }) async {
//     try {
//       await _noteInfoStorage.deleteNote(
//         userId: userId,
//         noteId: noteId,
//       );
//       state = state.where((note) => note.noteId != noteId).toList();
//     } catch (e) {
//       // Handle error
//       print('Error deleting note: $e');
//     }
//   }

//   Stream<QuerySnapshot> fetchNotesForUser({
//     required String? userId,
//   }) {
//     try {
//       return _noteInfoStorage.fetchNotesForUser(userId: userId);
//     } catch (e) {
//       print('Error fetching notes for user: $e');
//       return const Stream.empty();
//     }
//   }

//   Future<String?> getNoteDocumentId({
//     required UserId userId,
//     required NoteId noteId,
//   }) async {
//     try {
//       return await _noteInfoStorage.getNoteDocumentId(
//         userId: userId,
//         noteId: noteId,
//       );
//     } catch (e) {
//       // Handle error
//       print('Error getting note document ID: $e');
//       return null;
//     }
//   }
// }
