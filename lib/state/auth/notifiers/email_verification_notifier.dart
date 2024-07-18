import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmailVerificationNotifier extends StateNotifier<bool> {
  final User currentUser;
  bool _canRequestVerification = false;

  EmailVerificationNotifier({required this.currentUser}) : super(false) {
    _sendVerificationEmail();
    _startTimer();
  }

  Future<void> _sendVerificationEmail() async {
    if (!currentUser.emailVerified) {
      await currentUser.sendEmailVerification();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 30), () {
      _canRequestVerification = true;
    });
  }

  Future<void> requestVerificationEmail({
    required void Function(String) showMessageCallback,
  }) async {
    if (_canRequestVerification) {
      await _sendVerificationEmail();
      showMessageCallback('Verification email sent!');
      _canRequestVerification = false;
      _startTimer();
    } else {
      showMessageCallback(
          'We have sent you an email, please wait for 30 seconds and try again');
    }
  }

  Future<bool> checkEmailVerification() async {
    await currentUser.reload();
    final user = FirebaseAuth.instance.currentUser;
    bool emailVerified = user!.emailVerified;
    print('Reloaded user: ${emailVerified}');
    return emailVerified;
  }
}


// class EmailVerificationNotifier extends StateNotifier<bool> {
//   final User? currentUser;
//   bool _canRequestVerification = false;

//   EmailVerificationNotifier({required this.currentUser}) : super(false) {
//     _sendVerificationEmail();
//     _startTimer();
//   }

//   Future<void> _sendVerificationEmail() async {
//     await currentUser!.reload();
//     if (currentUser != null && !currentUser!.emailVerified) {
//       await currentUser!.sendEmailVerification();
//       // state = true; // Email sent successfully
//     }
//   }

//   void _startTimer() {
//     Future.delayed(const Duration(seconds: 30), () {
//       _canRequestVerification = true;
//     });
//   }

//   Future<void> requestVerificationEmail({
//     required void Function(String) showMessageCallback,
//   }) async {
//     if (_canRequestVerification == true) {
//       await _sendVerificationEmail();
//       showMessageCallback('Verification email sent!');
//       _canRequestVerification = false;
//       _startTimer();
//     } else {
//       showMessageCallback(
//           'We have sent you an email, please wait for 30 seconds and try again');
//     }
//   }

//   Future<bool> checkEmailVerification() async {
//     if (currentUser != null) {
//       await currentUser!.reload();
//       print('Reloaded user: ${currentUser!.emailVerified}');
//       return currentUser!.emailVerified;
//     }
//     return false;
//   }
// }

  // Future<bool> checkEmailVerification() async {
  //   if (currentUser!.emailVerified) {
  //     await currentUser!.reload();
  //     print('Reloaded user: ${currentUser!.emailVerified}');
  //     state = true; // Email verified
  //     return state;
  //   } else {
  //     state = false; // Email not verified yet
  //     return state;
  //   }
  // }






// class EmailVerificationNotifier extends StateNotifier<bool> {
//   final User? currentUser;
//   bool _canRequestVerification = false;

//   EmailVerificationNotifier({required this.currentUser}) : super(false) {
//     if (currentUser != null) {
//       _sendVerificationEmail();
//       _startTimer();
//     }
//   }

//   Future<void> _sendVerificationEmail() async {
//     if (currentUser != null && !currentUser!.emailVerified) {
//       await currentUser!.sendEmailVerification();
//     }
//   }

//   void _startTimer() {
//     Future.delayed(const Duration(seconds: 30), () {
//       _canRequestVerification = true;
//     });
//   }

//   Future<void> requestVerificationEmail({
//     required void Function(String) showMessageCallback,
//   }) async {
//     if (_canRequestVerification) {
//       await _sendVerificationEmail();
//       showMessageCallback('Verification email sent!');
//       _canRequestVerification = false;
//       _startTimer();
//     } else {
//       showMessageCallback(
//           'We have sent you an email, please wait for 30 seconds and try again');
//     }
//   }

//   Future<bool> checkEmailVerification() async {
//     if (currentUser != null) {
//       await currentUser!.reload();
//       print('Reloaded user: ${currentUser!.emailVerified}');
//       return currentUser!.emailVerified;
//     }
//     return false;
//   }
// }