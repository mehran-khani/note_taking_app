import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';
import 'package:note_taking_app/note/backend/note_info_storage.dart';

class EncryptionKeyNotifier with ChangeNotifier {
  String? _encryptionKey;
  String? get encryptionKey => _encryptionKey;
  final UserId? userId;

  final NoteInfoStorage _noteInfoStorage = const NoteInfoStorage();

  EncryptionKeyNotifier({
    required this.userId,
  });

  // New method to load encryption key for a specific user
  Future<String?> getEncryptionKeyForUser(UserId? userId) async {
    _encryptionKey = await _noteInfoStorage.getEncryptionKeyForUser(userId!);
    print('the _encryptionKey is: $_encryptionKey');
    notifyListeners();
    return _encryptionKey;
  }

  void clearEncryptionKey() {
    _encryptionKey = null;
    notifyListeners();
  }
}

  // Future<void> _loadEncryptionKey() async {
  //   if (!_keyLoaded) {
  //     _encryptionKey = await _noteInfoStorage.getEncryptionKeyForUser(userId!);
  //     print('the _encryptionKey is: $_encryptionKey');
  //     _keyLoaded = true;
  //     notifyListeners();
  //   }
  // }

  // Future<void> generateEncryptionKeyForUser(UserId? userId) async {
  //   if (_encryptionKey == null) {
  //     _encryptionKey =
  //         await _noteInfoStorage.generateEncryptionKeyForUser(userId!);
  //     print('the generated _encryptionKey is: $_encryptionKey');
  //     notifyListeners();
  //   } else {
  //     print('encryption key is not null');
  //   }
  // }