import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/state/local_auth/local_auth_notifier.dart';

final localAuthNotifierProvider =
    StateNotifierProvider<LocalAuthNotifier, bool>(
  (ref) => LocalAuthNotifier(),
);
