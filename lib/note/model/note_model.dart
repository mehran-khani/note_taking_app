import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String title,
    required String content,
    required String noteId,
    @FieldValueConverter() required DateTime createdAt,
    @FieldValueConverter() required DateTime updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  factory Note.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Note(
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      noteId: data['noteId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}

class FieldValueConverter implements JsonConverter<DateTime, Timestamp> {
  const FieldValueConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

extension NoteExtension on Note {
  Map<String, dynamic> toMap() => {
        'title': title,
        'content': content,
        'note_id': noteId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
