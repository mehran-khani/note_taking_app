// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      title: json['title'] as String,
      content: json['content'] as String,
      noteId: json['noteId'] as String,
      createdAt:
          const FieldValueConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const FieldValueConverter().fromJson(json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'noteId': instance.noteId,
      'createdAt': const FieldValueConverter().toJson(instance.createdAt),
      'updatedAt': const FieldValueConverter().toJson(instance.updatedAt),
    };
