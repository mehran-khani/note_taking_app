import 'package:flutter/foundation.dart' show immutable;
import 'package:note_taking_app/state/auth/models/auth_result.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';

@immutable
class AuthState {
  final AuthResult? authResult;
  final bool isLoading;
  final UserId? userId;

  const AuthState({
    required this.authResult,
    required this.isLoading,
    required this.userId,
  });

  const AuthState.loggedOut()
      : authResult = null,
        isLoading = false,
        userId = null;

  AuthState copyWithIsLoading(bool isLoading) => AuthState(
        authResult: authResult,
        isLoading: isLoading,
        userId: userId,
      );

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (authResult == other.authResult &&
          isLoading == other.isLoading &&
          userId == other.userId);

  @override
  int get hashCode => Object.hash(
        authResult,
        userId,
        isLoading,
      );
}
