import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';
import 'package:note_taking_app/note/model/note_model.dart';
import 'package:note_taking_app/state/constants/firebase_collection_name.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

@immutable
class NoteInfoStorage {
  const NoteInfoStorage();
  final _storage = const FlutterSecureStorage();

  Future<Uint8List> _secureRandomBytes(int length) async {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (index) => random.nextInt(256));
    return Uint8List.fromList(bytes);
  }

  Future<String> _generateKey() async {
    final secureRandomBytes = await _secureRandomBytes(16);
    final key = base64Url.encode(secureRandomBytes);

    print('Encryption key generated and stored: $key');

    return key;
  }

  Future<String> _generateEncryptionKeyForUser(UserId userId) async {
    if (userId.isEmpty) {
      throw Exception('Invalid userId');
    }

    final key = await _generateKey();
    await _storage.write(key: 'encryption_key_$userId', value: key);
    return key;
  }

  Future<String?> getEncryptionKeyForUser(UserId userId) async {
    final encryptionKey = await _storage.read(key: 'encryption_key_$userId');
    if (encryptionKey != null) {
      return encryptionKey;
    } else {
      print(
          'getEncryptionKeyForUser_error: Encryption key not found for user $userId');
      final encryptionKey = _generateEncryptionKeyForUser(userId);
      return encryptionKey;
    }
  }

// Encrypt note data before storing in Firestore
  Future<String> encryptNoteData(String data, UserId userId) async {
    try {
      final key = await getEncryptionKeyForUser(userId);
      if (key == null) {
        throw Exception('Encryption key not found for user $userId');
      }

      // Check if the data is empty
      if (data.isEmpty) {
        // If data is empty, return an empty string without encryption
        return '';
      }

      final iv = encrypt.IV(Uint8List(16));
      final keyObject = encrypt.Key.fromUtf8(key);
      final encrypter = encrypt.Encrypter(encrypt.AES(keyObject));

      final encryptedData = encrypter.encrypt(data, iv: iv);
      return encryptedData.base64;
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  Future<String> decryptNoteData(String encryptedData, UserId userId) async {
    try {
      // Retrieve encryption key for the user
      final key = await getEncryptionKeyForUser(userId);

      if (key == null) {
        throw Exception('Encryption key not found for user $userId');
      }

      // Check if the encrypted data is empty
      if (encryptedData.isEmpty) {
        // If encrypted data is empty, return an empty string without decryption
        return '';
      }

      // Decrypt encrypted data using encryption key
      final iv = encrypt.IV(Uint8List(16));
      final keyObject = encrypt.Key.fromUtf8(key);
      final encrypter = encrypt.Encrypter(encrypt.AES(keyObject));

      final decryptedData = encrypter.decrypt64(encryptedData, iv: iv);
      return decryptedData;
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  // Method to add a new encrypted note
  Future<void> addEncryptedNote({
    required UserId userId,
    required Note note,
  }) async {
    final String title = note.title;
    final String content = note.content;

    try {
      // Encrypt title and content
      final encryptedTitle = await encryptNoteData(title, userId);
      final encryptedContent = await encryptNoteData(content, userId);

      // Create a new Note object with encrypted title and content
      final encryptedNote = Note(
        title: encryptedTitle,
        content: encryptedContent,
        noteId: note.noteId,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );

      // Store the encrypted note in Firestore
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.notes)
          .doc(note.noteId)
          .set(encryptedNote.toJson());
    } catch (e) {
      // Handle error
      throw Exception('Error adding note: $e');
    }
  }

  // Method to delete a note
  Future<void> deleteNote({
    required UserId userId,
    required NoteId noteId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .collection(FirebaseCollectionName.notes)
          .doc(noteId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}

// Encrypt note data before storing in Firestore
// Future<Map<String, String>> encryptNoteData(String data, UserId userId) async {
//   try {
//     final key = await getEncryptionKeyForUser(userId);
//     if (key == null) {
//       throw Exception('Encryption key not found for user $userId');
//     }

//     final iv = encrypt.IV.fromLength(16);
//     final keyObject = encrypt.Key.fromUtf8(key);
//     final encrypter = encrypt.Encrypter(encrypt.AES(keyObject));

//     final encryptedData = encrypter.encrypt(data, iv: iv);
//     return {
//       'encryptedData': encryptedData.base64,
//       'iv': iv.base64,
//     };
//   } catch (e) {
//     throw Exception('Encryption failed: $e');
//   }
// }

// // Decrypt note data after retrieving from Firestore
// Future<String> decryptNoteData(String encryptedData, String ivString, UserId userId) async {
//   try {
//     // Retrieve encryption key for the user
//     final key = await getEncryptionKeyForUser(userId);

//     if (key == null) {
//       throw Exception('Encryption key not found for user $userId');
//     }

//     final iv = encrypt.IV.fromBase64(ivString);
//     final keyObject = encrypt.Key.fromUtf8(key);
//     final encrypter = encrypt.Encrypter(encrypt.AES(keyObject));

//     final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
//     final decryptedData = encrypter.decrypt(encrypted, iv: iv);
//     return decryptedData;
//   } catch (e) {
//     throw Exception('Decryption failed: $e');
//   }
// }

  // // Method to add a new note
  // Future<void> addNote({
  //   required UserId userId,
  //   required Note note,
  // }) async {
  //   final String title = note.title;
  //   final String content = note.content;

  //   try {
  //     final notePayload = Note(
  //       title: title,
  //       content: content,
  //       noteId: note.noteId,
  //       createdAt: note.createdAt,
  //       updatedAt: note.updatedAt,
  //     );

  //     // final newNoteRef =
  //     await FirebaseFirestore.instance
  //         .collection(FirebaseCollectionName.users)
  //         .doc(userId)
  //         .collection(FirebaseCollectionName.notes)
  //         .doc(note.noteId)
  //         .set(notePayload.toJson());
  //   } catch (e) {
  //     // Handle error
  //     throw Exception('Error adding note: $e');
  //   }
  // }