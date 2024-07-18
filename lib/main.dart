import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/firebase_options.dart';
import 'package:note_taking_app/views/notes/main_view.dart';
import 'package:note_taking_app/note/model/note_model.dart';
import 'package:note_taking_app/views/auth/auth_screen.dart';
import 'package:note_taking_app/views/splash/splash_screen.dart';
import 'package:note_taking_app/views/notes/create_and_update.dart';
import 'package:note_taking_app/views/auth/email_verification_screen.dart';
import 'package:note_taking_app/state/auth/provider/auth_state_provider.dart';
import 'package:note_taking_app/state/auth/provider/is_logged_in_provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'Note_taking_app',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final currentUser = ref.read(authStateProvider.notifier).currentUser;

    // final userAsyncValue = ref.read(userProvider);
    // final user = userAsyncValue.maybeWhen(
    //   data: (user) => user,
    //   orElse: () => null,
    // );

    final GoRouter router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation:
          // '/auth',
          '/splash',
      routes: <RouteBase>[
        GoRoute(
          path: '/splash',
          builder: (BuildContext context, GoRouterState state) {
            return SplashScreen(
              onInitializationComplete: () {
                GoRouter.of(context).pushReplacement(!isLoggedIn
                    ? '/auth'
                    : currentUser!.emailVerified
                        ? '/'
                        : '/email-verification');
              },
            );
          },
        ),
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const MainScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'edit',
              builder: (BuildContext context, GoRouterState? state) {
                Note? note = state?.extra as Note?;
                return CreateAndUpdateNotes(note);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) {
            return const AuthScreen();
          },
        ),
        GoRoute(
          path: '/email-verification',
          builder: (context, state) => const EmailVerificationScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
