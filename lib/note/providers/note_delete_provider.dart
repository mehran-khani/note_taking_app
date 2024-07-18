import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';
import 'package:note_taking_app/note/notifiers/note_delete_notifier.dart';

final noteDelteProvider = StateNotifierProvider<NoteDeleteNotifier, IsLoading>(
  (ref) => NoteDeleteNotifier(),
);
