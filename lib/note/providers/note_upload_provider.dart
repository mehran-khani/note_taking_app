import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';
import 'package:note_taking_app/note/notifiers/note_upload_notifier.dart';

final noteUploadProvider = StateNotifierProvider<NoteUploadNotifier, IsLoading>(
  (ref) => NoteUploadNotifier(),
);
