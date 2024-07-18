import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';
import 'package:note_taking_app/state/auth/models/auth_result.dart';
import 'package:note_taking_app/state/auth/constants/constant.dart';

// this part does the talking to the firebase for authentication
// it gets the
// current user
// user id
// is already logged in
// name
// email
// and also the functions of signing in and out

class Authenticator {
  const Authenticator();

  User? get currentUser => FirebaseAuth.instance.currentUser;

  UserId? get userId => currentUser?.uid;
  bool get isAlreadyLogged => userId != null;
  String get name => currentUser?.displayName ?? '';
  String? get email => currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<AuthResult> loginWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ["email", "public_profile"]);
    // print('this is the login status ${loginResult.status}');

    // if (loginResult.status == LoginStatus.success) {
    //   // you are logged
    //   final AccessToken accessToken = loginResult.accessToken!;
    //   // print(accessToken.token);
    // } else {
    //   print(loginResult.status);
    //   print(loginResult.message);
    // }

    final token = loginResult.accessToken?.token;
    if (token == null) {
      return AuthResult.aborted;
    }
    final oauthCredentials = FacebookAuthProvider.credential(token);
    try {
      await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      await currentUser?.reload();
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      final email = e.email;
      final credential = e.credential;
      // print('this is credential $credential');
      if (e.code == AuthTexts.accountExists &&
          email != null &&
          credential != null) {
        final providers =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        print('$providers');
        print('this is the provider $providers');
        if (providers.contains(AuthTexts.googleCome)) {
          // print('we are here');
          await currentUser?.reload();
          final user = FirebaseAuth.instance.currentUser;
          print('this is the user $user');
          await loginWithGoogle();
          await user?.linkWithCredential(credential);
          return AuthResult.success;
        }
      }
      print(e);
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        AuthTexts.email,
      ],
    );

    final signInAccount = await googleSignIn.signIn();

    if (signInAccount == null) {
      return AuthResult.aborted;
    }

    final googleAuth = await signInAccount.authentication;

    final oAuthCredentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(oAuthCredentials);
      // print('Logged in with Google successfully.');
      return AuthResult.success;
    } catch (e) {
      // print('Error logging in with Google: $e');
      return AuthResult.failure;
    }
  }

  Future<AuthResult> signUpWithEmailAndPassword({
    required Email email,
    required String password,
  }) async {
    try {
      // create a new user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // User created successfully
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return AuthResult.failure;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return AuthResult.failure;
      } else if (e.code == 'operation-not-allowed') {
        print('The operation is not allowed.');
        return AuthResult.failure;
      } else if (e.code == 'invalid-email') {
        print('The email is invalid.');
        return AuthResult.failure;
      }
      return AuthResult.failure;
    } catch (e) {
      // Handle other errors
      print(e);
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithEmail(
      {required Email email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthResult.failure;
      } else if (e.code == 'wrong-password') {
        return AuthResult.failure;
      } else if (e.code == 'invalid-email') {
        return AuthResult.failure;
      } else if (e.code == 'user-disabled') {
        return AuthResult.failure;
      }
      return AuthResult.failure;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}


  //TODO: the login with facebook does not work it does not log in
  // Future<AuthResult> loginWithFacebook() async {
  //   final loginResult = await FacebookAuth.instance.login();
  //   final userToken = loginResult.accessToken?.userId;

  //   print(
  //       'Facebook Access Token: $userToken'); // Add this line to print the token

  //   if (userToken == null) {
  //     //user has aborted the login process
  //     return AuthResult.aborted;
  //   }

  //   final oAuthCredential = FacebookAuthProvider.credential(userToken);

  //   print(oAuthCredential);

  //   try {
  //     await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
  //     return AuthResult.success;
  //   } on FirebaseAuthException catch (e) {
  //     final email = e.email;
  //     final credential = e.credential;

  //     if (e.code == AuthTexts.accountExists &&
  //         email != null &&
  //         credential != null) {
  //       QuerySnapshot query = await FirebaseFirestore.instance
  //           .collection('users')
  //           .where("email", isEqualTo: email)
  //           .get();

  //       if (query.docs.isNotEmpty) {
  //         // Email is already used...
  //         await loginWithGoogle();
  //         FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
  //       }
  //       return AuthResult.success;
  //     }
  //     print('Error logging in with Facebook: $e');
  //     return AuthResult.failure;
  //   }
  // }