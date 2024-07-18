// import 'package:flutter/cupertino.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:note_taking_app/state/auth/provider/user_id_provider.dart';
// import 'package:note_taking_app/state/auth/provider/user_name_provider.dart';
// import 'package:note_taking_app/views/animations/error_animation.dart';
// import 'package:note_taking_app/views/animations/loading_animation.dart';

// class UserInfo extends ConsumerWidget {
//   const UserInfo({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userId = ref.watch(userIdProvider);
//     final userInfo = ref.watch(userInfoProvider(userId!));

//     return userInfo.when(
//       data: (userInfoModel) {
//         return Text(userInfoModel.userName.toString().toUpperCase());
//       },
//       error: (error, stackTrace) {
//         return const ErrorAnimationView();
//       },
//       loading: () {
//         return const Center(
//           child: LoadingAnimationView(),
//         );
//       },
//     );
//   }
// }
