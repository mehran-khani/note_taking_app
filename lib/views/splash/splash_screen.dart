import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/note/providers/encryption_key_provider.dart';
import 'package:note_taking_app/state/auth/provider/user_id_provider.dart';
import 'package:note_taking_app/views/animations/loading_animation.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashScreen({
    super.key,
    required this.onInitializationComplete,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      final userId = ref.read(userIdProvider);

      try {
        await ref
            .read(encryptionKeyProvider.notifier)
            .getEncryptionKeyForUser(userId);
      } catch (e) {
        print(e);
      }
      // print(FirebaseAuth.instance.currentUser?.uid ?? 'there is no user here');
      // Simulate initialization tasks such as network calls, etc.
      // Once initialization is complete, call the onInitializationComplete callback
      await Future.delayed(const Duration(milliseconds: 5000));

      widget.onInitializationComplete();
    } catch (e) {
      // Handle initialization error
      print('Initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // SplashAnimationView(),
            LoadingAnimationView(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
