import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';
import 'package:note_taking_app/state/auth/models/auth_state.dart';
import 'package:note_taking_app/state/auth/models/auth_result.dart';
import 'package:note_taking_app/user/backend/user_info_storage.dart';
import 'package:note_taking_app/state/auth/backend/authenticator.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();
  AuthStateNotifier() : super(const AuthState.loggedOut()) {
    if (_authenticator.isAlreadyLogged) {
      state = AuthState(
        authResult: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
  }

  User? get currentUser => _authenticator.currentUser;
  // User? currentUser() {
  //   final currentUser = _authenticator.currentUser;
  //   return currentUser;
  // }

  Future<void> logOut() async {
    state = state.copyWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.loggedOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _authenticator.resetPassword(email);
  }

  Future<void> loginWithGoogle() async {
    state = state.copyWithIsLoading(true);

    final result = await _authenticator.loginWithGoogle();
    // print('result is: $result');
    final userId = _authenticator.userId;
    // print('userId is: $userId');

    try {
      if (result == AuthResult.success && userId != null) {
        await saveUserInfo(userId: userId);
      }
    } on FirebaseException catch (e) {
      print('the error is : $e');
    }

    state = AuthState(
      authResult: result,
      isLoading: false,
      userId: userId,
    );
  }

  Future<void> loginWithFacebook() async {
    state = state.copyWithIsLoading(true);

    final result = await _authenticator.loginWithFacebook();
    print('this is the result $result');
    await currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    print('this is the user id $userId');

    try {
      if (result == AuthResult.success && userId != null) {
        await saveUserInfo(userId: userId);
      }
    } on FirebaseException catch (e) {
      print('the error is : $e');
    }

    state = AuthState(
      authResult: result,
      isLoading: false,
      userId: userId,
    );
  }

  Future<void> signUpWithEmailAndPassword({
    required Email email,
    required String password,
  }) async {
    state = state.copyWithIsLoading(true);
    try {
      final result = await _authenticator.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = _authenticator.userId;

      if (_authenticator.currentUser!.emailVerified) {
        state = AuthState(
          authResult: AuthResult.emailVerify,
          isLoading: false,
          userId: userId,
        );
      }

      if (result == AuthResult.success && userId != null) {
        await saveUserInfo(userId: userId);
      }

      state = AuthState(
        authResult: result,
        isLoading: false,
        userId: userId,
      );
    } on FirebaseAuthException catch (e) {
      print('$e');
      state = const AuthState(
        authResult: AuthResult.failure,
        isLoading: false,
        userId: null,
      );
      throw ('$e');
    } catch (e) {
      print('$e');
      const AuthState(
        authResult: AuthResult.failure,
        isLoading: false,
        userId: null,
      );
      throw ('$e');
    }
  }

  Future<void> loginInWithEmail({
    required Email email,
    required String password,
  }) async {
    state = state.copyWithIsLoading(true);

    final result = await _authenticator.loginWithEmail(
      email: email,
      password: password,
    );
    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }

    state = AuthState(
      authResult: result,
      isLoading: false,
      userId: userId,
    );
  }

  Future<void> saveUserInfo({required UserId userId}) {
    try {
      return _userInfoStorage.saveAndUpdateUserInfo(
          userId: userId,
          userName: _authenticator.name,
          email: _authenticator.email);
    } catch (e) {
      print('is it $e');
      throw (e);
    }
  }
}
