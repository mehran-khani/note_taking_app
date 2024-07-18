import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/note/notifiers/encryption_key_notifier.dart';
import 'package:note_taking_app/state/auth/provider/user_id_provider.dart';

final encryptionKeyProvider = ChangeNotifierProvider(
  (ref) {
    final userId = ref.read(userIdProvider); // Fetch userId first
    return EncryptionKeyNotifier(userId: userId);
  },
);
