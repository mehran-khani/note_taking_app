// import 'package:flutter/foundation.dart';
// import 'package:note_taking_app/note/model/note_model.dart';
// import 'package:note_taking_app/note/state_models/note_result.dart';

// // @immutable
// // class NoteState {
// //   final List<Note> notes;

// //   const NoteState({
// //     required this.notes,
// //   });

// //   factory NoteState.initial() => const NoteState(notes: []);

// //   NoteState addNote(Note note) => NoteState(
// //         notes: [...notes, note],
// //       );

// //   NoteState removeNoteById(String noteId) => NoteState(
// //         notes: notes.where((note) => note.noteId != noteId).toList(),
// //       );

// //   @override
// //   bool operator ==(covariant NoteState other) =>
// //       identical(this, other) || listEquals(notes, other.notes);

// //   @override
// //   int get hashCode => notes.hashCode;
// // }

// @immutable
// class NoteState {
//   final NoteResult? noteResult;
//   final bool isLoading;
//   final List<Note>? notes;

//   const NoteState({
//     required this.noteResult,
//     required this.isLoading,
//     required this.notes,
//   });

//   const NoteState.initial()
//       : noteResult = null,
//         isLoading = false,
//         notes = const [];

//   NoteState copyWithIsLoading(bool isLoading) => NoteState(
//         noteResult: noteResult,
//         isLoading: isLoading,
//         notes: notes,
//       );

//   NoteState copyWithNoteResult(NoteResult? noteResult) => NoteState(
//         noteResult: noteResult,
//         isLoading: isLoading,
//         notes: notes,
//       );

//   @override
//   bool operator ==(covariant NoteState other) =>
//       identical(this, other) ||
//       (noteResult == other.noteResult &&
//           isLoading == other.isLoading &&
//           listEquals(notes, other.notes));

//   @override
//   int get hashCode => Object.hash(
//         noteResult,
//         isLoading,
//         notes,
//       );
// }
