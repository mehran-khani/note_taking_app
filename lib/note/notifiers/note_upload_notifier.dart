import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';
import 'package:note_taking_app/note/backend/note_info_storage.dart';
import 'package:note_taking_app/note/model/note_model.dart';

class NoteUploadNotifier extends StateNotifier<IsLoading> {
  NoteUploadNotifier() : super(false);

  final _noteInfoStorage = const NoteInfoStorage();
  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required Note note,
    required UserId userId,
  }) async {
    isLoading = true;

    await _noteInfoStorage.addEncryptedNote(
      userId: userId,
      note: note,
    );
    isLoading = false;
    return true;
  }
}
