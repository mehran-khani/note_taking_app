import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalAuth {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> authenticateWithBiometrics() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        throw Exception('Biometric authentication is not available');
      }
      final isAuthenticated = await _isAuthenticated();
      if (isAuthenticated == true) {
        return true;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your Notes',
      );

      if (didAuthenticate) {
        await _setAuthState(true);
        return true; // Indicate successful authentication
      } else {
        return false; // Indicate authentication failure
      }
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

  Future<bool> _isAuthenticated() async {
    try {
      final isAuthenticated = await _storage.read(key: 'isAuthenticated');

      return isAuthenticated == 'true';
    } catch (e) {
      print('Error reading authentication state: $e');
      return false;
    }
  }

  Future<void> _setAuthState(bool isAuthenticated) async {
    try {
      await _storage.write(
          key: 'isAuthenticated', value: isAuthenticated.toString());
    } catch (e) {
      print('Error writing authentication state: $e');
    }
  }
}
