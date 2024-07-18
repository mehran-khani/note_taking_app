import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';
import 'package:note_taking_app/state/constants/firebase_collection_name.dart';
import 'package:note_taking_app/state/constants/firebase_field_name.dart';
import 'package:note_taking_app/user/model/user_model.dart' as user_model
    show UserModel;

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveAndUpdateUserInfo({
    required UserId userId,
    required UserName userName,
    required Email? email,
  }) async {
    try {
      // first we check if we have the same user's info from before
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFieldName.uId, isEqualTo: userId)
          .limit(1)
          .get();

      print(userInfo);

      if (userInfo.docs.isNotEmpty) {
        //we already have this user's info
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: userName,
          FirebaseFieldName.email: email,
        });
        return true;
      }

      //we don't have this user's info from beofre. create a new user
      final userPayload = user_model.UserModel(
        uid: userId,
        emailVerified: false,
        userName: userName,
        email: email,
      );
      print(userPayload.userName ?? 'there is not username');
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .set(
            userPayload.toJson(),
          );
      return true;
    } catch (e) {
      print('the problem is here: $e');
      return false;
    }
  }
}
