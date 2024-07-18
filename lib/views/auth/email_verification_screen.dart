import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/state/auth/provider/auth_state_provider.dart';
import 'package:note_taking_app/state/auth/provider/email_verification_provider.dart';

class EmailVerificationScreen extends ConsumerWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        leading: BackButton(
          onPressed: () async {
            await ref.read(authStateProvider.notifier).logOut();
            GoRouter.of(context).pushReplacement('/auth');
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please verify your email to continue.'),
            Text(
                'Is this your email? ${ref.read(authStateProvider.notifier).currentUser!.email}'),
            const SizedBox(height: 44),
            ElevatedButton(
              onPressed: () => _sendVerificationEmail(context, ref),
              child: const Text('Resend Verification Email'),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () async {
                // const Authenticator().userReload();
                await _checkEmailVerification(context, ref);
              },
              child: const Text('I have verified my email'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendVerificationEmail(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(emailVerificationProvider.notifier);
    try {
      await notifier.requestVerificationEmail(
        showMessageCallback: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email: ${e.message}'),
        ),
      );
    }
  }

  Future<void> _checkEmailVerification(
      BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(emailVerificationProvider.notifier);
    try {
      final emailVerified = await notifier.checkEmailVerification();
      print('Email verified: $emailVerified');
      if (emailVerified) {
        GoRouter.of(context).pushReplacement('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not verified yet.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reload user: ${e.toString()}')),
      );
    }
  }
}


// class EmailVerificationScreen extends ConsumerWidget {
//   const EmailVerificationScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentUser = ref.read(authStateProvider.notifier).currentUser();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Email Verification'),
//         leading: BackButton(
//           onPressed: () async {
//             await ref.read(authStateProvider.notifier).logOut();
//             GoRouter.of(context).pushReplacement('/auth');
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Please verify your email to continue.'),
//             const SizedBox(
//               height: 44,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _sendVerificationEmail(context, ref);
//               },
//               child: const Text('Resend Verification Email'),
//             ),
//             const SizedBox(
//               height: 22,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _checkEmailVerification(context, ref);
//               },
//               child: const Text('I have verified my email'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 currentUser?.reload();
//                 print(currentUser);
//               },
//               child: const Text('emailverified'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _sendVerificationEmail(BuildContext context, WidgetRef ref) async {
//     final notifier = ref.read(emailVerificationProvider.notifier);
//     try {
//       await notifier.requestVerificationEmail(
//         showMessageCallback: (message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(message),
//             ),
//           );
//         },
//       );
//     } on FirebaseException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to send verification email, ${e.toString()}'),
//         ),
//       );
//     }
//   }

//   Future<void> _checkEmailVerification(
//       BuildContext context, WidgetRef ref) async {
//     final notifier = ref.read(emailVerificationProvider.notifier);
//     try {
//       final emailVerified = await notifier.checkEmailVerification();
//       print('Email verified: $emailVerified');
//       if (emailVerified == true) {
//         GoRouter.of(context).pushReplacement('/');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Email not verified yet.'),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to reload user: ${e.toString()}'),
//         ),
//       );
//     }
//   }
// }

  // Future<void> _checkEmailVerification(
  //     BuildContext context, WidgetRef ref) async {
  //   final emailverified = await ref
  //       .read(emailVerificationProvider.notifier)
  //       .checkEmailVerification();

  //   if (emailverified) {
  //     GoRouter.of(context).pushReplacement('/');
  //   } else if (!emailverified) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Email not verified yet.'),
  //       ),
  //     );
  //   } else {
  //     print('i dont know');
  //   }
  // }




  // class EmailVerificationScreen extends ConsumerWidget {
//   const EmailVerificationScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentUser = ref.read(authStateProvider.notifier).currentUser();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Email Verification'),
//         leading: BackButton(
//           onPressed: () async {
//             await ref.read(authStateProvider.notifier).logOut();
//             GoRouter.of(context).pushReplacement('/auth');
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Please verify your email to continue.'),
//             const SizedBox(height: 44),
//             ElevatedButton(
//               onPressed: () => _sendVerificationEmail(context, ref),
//               child: const Text('Resend Verification Email'),
//             ),
//             const SizedBox(height: 22),
//             ElevatedButton(
//               onPressed: () => _checkEmailVerification(context, ref),
//               child: const Text('I have verified my email'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await currentUser?.reload();
//                 print(currentUser);
//               },
//               child: const Text('emailverified'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _sendVerificationEmail(BuildContext context, WidgetRef ref) async {
//     final notifier = ref.read(emailVerificationProvider.notifier);
//     try {
//       await notifier.requestVerificationEmail(
//         showMessageCallback: (message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message)),
//           );
//         },
//       );
//     } on FirebaseException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to send verification email: ${e.message}'),
//         ),
//       );
//     }
//   }

//   Future<void> _checkEmailVerification(
//       BuildContext context, WidgetRef ref) async {
//     final notifier = ref.read(emailVerificationProvider.notifier);
//     try {
//       final emailVerified = await notifier.checkEmailVerification();
//       print('Email verified: $emailVerified');
//       if (emailVerified) {
//         GoRouter.of(context).pushReplacement('/');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Email not verified yet.')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to reload user: ${e.toString()}')),
//       );
//     }
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:note_taking_app/state/auth/provider/auth_state_provider.dart';

// class EmailVerificationScreen extends StatelessWidget {
//   const EmailVerificationScreen({super.key});

//   void _sendVerificationEmail(BuildContext context, WidgetRef ref) async {
//     final currentUser = ref.read(authStateProvider.notifier).currentUser();
//     if (currentUser != null && !currentUser.emailVerified) {
//       await currentUser.sendEmailVerification();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Email Verification'),
//         // leading: BackButton(
//         //   onPressed: () {
//         //     GoRouter.of(context).pushReplacement('/auth');
//         //   },
//         // ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Please verify your email to continue.'),
//             Consumer(
//               builder: (_, WidgetRef ref, __) {
//                 return ElevatedButton(
//                   onPressed: () {
//                     try {
//                       _sendVerificationEmail(context, ref);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Verification email sent!'),
//                         ),
//                       );
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                               'Failed to send verification email / ${e.toString()}'),
//                         ),
//                       );
//                     }
//                   },
//                   child: const Text('Send Verification Email'),
//                 );
//               },
//             ),
//             Consumer(
//               builder: (_, WidgetRef ref, __) {
//                 return ElevatedButton(
//                   onPressed: () {
//                     final currentUser =
//                         ref.read(authStateProvider.notifier).currentUser();
//                     if (currentUser != null) {
//                       currentUser.reload().then((_) async {
//                         Future.delayed(const Duration(seconds: 1));
//                         if (currentUser.emailVerified) {
//                           GoRouter.of(context).pushReplacement('/');
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Email not verified yet.'),
//                             ),
//                           );
//                         }
//                       }).catchError((error) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Failed to reload user: $error'),
//                           ),
//                         );
//                       });
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('User does not exist'),
//                         ),
//                       );
//                     }
//                   },
//                   child: const Text('I have verified my email'),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
