import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/state/auth/models/auth_result.dart';
import 'package:note_taking_app/state/auth/provider/auth_state_provider.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.authResult == AuthResult.success;
});
