// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:note_taking_app/widgets/button.dart';
// import 'package:note_taking_app/widgets/text_field.dart';

// class LoginScreen extends ConsumerWidget {
//   LoginScreen({super.key});
//   final TextEditingController emial = TextEditingController();
//   final TextEditingController password = TextEditingController();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Icon(
//               CupertinoIcons.question,
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height * 0.8,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextFieldWidget(
//                 hintText: 'Email',
//                 textEditingController: emial,
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               TextFieldWidget(
//                 hintText: 'Password',
//                 textEditingController: password,
//               ),
//               const SizedBox(
//                 height: 32,
//               ),
//               Button(
//                 text: 'Sign Up',
//                 icon: CupertinoIcons.checkmark_circle,
//                 onPressed: () {
//                   GoRouter.of(context).pushReplacement('/notes');
//                 },
//               ),
//               Expanded(
//                 child: Align(
//                   alignment: FractionalOffset.bottomCenter,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text('Dont\'t have an account?'),
//                       Button(
//                         onPressed: () {
//                           GoRouter.of(context).pushReplacement('/sign-up');
//                         },
//                         text: 'Sign Up',
//                         icon: Icons.login,
//                         color: Colors.transparent,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
