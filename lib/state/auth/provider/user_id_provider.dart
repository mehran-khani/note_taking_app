import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/state/auth/provider/auth_state_provider.dart';
import 'package:note_taking_app/constants/type_def/type_def.dart';

final userIdProvider = Provider<UserId?>(
  (ref) => ref.watch(authStateProvider).userId,
);
