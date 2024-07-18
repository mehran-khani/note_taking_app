import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';
import 'package:note_taking_app/note/backend/note_info_storage.dart';

class NoteDeleteNotifier extends StateNotifier<IsLoading> {
  NoteDeleteNotifier() : super(false);

  final _noteInfoStorage = const NoteInfoStorage();
  set isLoading(bool value) => state = value;

  Future<bool> delete({
    required NoteId noteId,
    required UserId userId,
  }) async {
    isLoading = true;

    await _noteInfoStorage.deleteNote(
      userId: userId,
      noteId: noteId,
    );
    isLoading = false;
    return true;
  }
}
