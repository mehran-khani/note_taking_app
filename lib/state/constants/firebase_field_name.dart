import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/widgets.dart';

@immutable
class FirebaseFieldName {
  static const displayName = 'userName';
  static const email = 'email';
  static const uId = 'uid';
  static const noteId = 'noteId';
  static const content = 'content';
  static const title = 'title';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
  const FirebaseFieldName._();
}
