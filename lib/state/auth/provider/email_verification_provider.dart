import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/state/auth/provider/auth_state_provider.dart';
import 'package:note_taking_app/state/auth/notifiers/email_verification_notifier.dart';

final emailVerificationProvider =
    StateNotifierProvider<EmailVerificationNotifier, bool>((ref) {
  final currentUser = ref.watch(authStateProvider.notifier).currentUser;
  if (currentUser != null) {
    return EmailVerificationNotifier(currentUser: currentUser);
  } else {
    throw StateError('No user is currently logged in.');
  }
});



// final emailVerificationProvider =
//     StateNotifierProvider<EmailVerificationNotifier, bool>((ref) {
//   final currentUser = ref.read(authStateProvider.notifier).currentUser();
//   return EmailVerificationNotifier(currentUser: currentUser!);
// });
// final userProvider = StreamProvider<User?>((ref) {
//   return FirebaseAuth.instance.authStateChanges();
// });


// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:note_taking_app/constants/type_def/type_def.dart';
// import 'package:note_taking_app/state/constants/firebase_collection_name.dart';
// import 'package:note_taking_app/state/constants/firebase_field_name.dart';
// import 'package:note_taking_app/user/model/user_model.dart';

// final userInfoProvider =
//     StreamProvider.family.autoDispose<UserModel, UserId>((ref, UserId userId) {
//   final controller = StreamController<UserModel>();

//   final sub = FirebaseFirestore.instance
//       .collection(FirebaseCollectionName.users)
//       .where(
//         FirebaseFieldName.uId,
//         isEqualTo: userId,
//       )
//       .limit(1)
//       .snapshots()
//       .listen((snapshot) {
//     final doc = snapshot.docs.first;
//     final json = doc.data();
//     final userInfoModel = UserModel.fromJson(json);
//     controller.add(userInfoModel);
//   });

//   ref.onDispose(() {
//     sub.cancel();
//     controller.close();
//   });
//   return controller.stream;
// });
