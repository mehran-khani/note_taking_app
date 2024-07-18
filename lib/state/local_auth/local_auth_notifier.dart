import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/state/local_auth/local_auth.dart';

class LocalAuthNotifier extends StateNotifier<bool> {
  final LocalAuth _localAuth = LocalAuth();

  LocalAuthNotifier() : super(false);

  Future<bool> authenticateWithBiometrics() async {
    try {
      await _localAuth.authenticateWithBiometrics();
      state = true;
      return true;
    } catch (error) {
      state = false;
      print("Error during biometric authentication: $error");
      return false;
    }
  }
}
