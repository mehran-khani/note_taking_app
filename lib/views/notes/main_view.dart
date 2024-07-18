import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/widgets/dialogs/logout_dialog.dart';
import 'package:note_taking_app/views/notes/widgets/notes_list.dart';
import 'package:note_taking_app/widgets/dialogs/custom_alert_dialog.dart';
import 'package:note_taking_app/state/auth/provider/auth_state_provider.dart';
import 'package:note_taking_app/views/notes/widgets/searched_notes_list.dart';
import 'package:note_taking_app/note/providers/notes_by_search_term_provider.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchTerm = useTextEditingController();
    final searchText = useState('');
    final user = ref.read(authStateProvider.notifier).currentUser;

    useEffect(() {
      searchTerm.addListener(() {
        // Rebuild the widget when search term changes
        ref.refresh(notesBySearchTermProvider(searchTerm.text));
      });
      return null;
    }, [searchTerm]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          TextButton(
            onPressed: () {
              print(user);
            },
            child: const Text('User'),
          ),
          TextButton(
            onPressed: () async {
              final shouldLogout = await const LogoutDialog()
                  .present(context)
                  .then((value) => value ?? false);

              if (shouldLogout) {
                ref.read(authStateProvider.notifier).logOut();
              }
            },
            child: const Text('log out'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44),
                color: Colors.white,
              ),
              child: TextField(
                controller: searchTerm,
                onChanged: (value) {
                  searchText.value = value;
                  // refresh the provider to refresh the data
                  ref.refresh(notesBySearchTermProvider(value));
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchTerm.clear();
                      searchText.value = '';
                      ref.refresh(notesBySearchTermProvider(''));
                    },
                    icon: const Icon(CupertinoIcons.clear),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: searchTerm.text.isEmpty
                  ? const Notes()
                  : SearchedNotes(searchTerm: searchTerm.text),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the notes screen
          GoRouter.of(context).go('/edit');
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

// class MainScreen extends HookConsumerWidget {
//   const MainScreen({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final searchTerm = useTextEditingController();
//     final user = ref.read(authStateProvider.notifier).currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Welcome'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               print(user);
//             },
//             child: const Text('User'),
//           ),
//           TextButton(
//             onPressed: () async {
//               final shouldLogout = await const LogouteDialog()
//                   .present(context)
//                   .then((value) => value ?? false);

//               if (shouldLogout) {
//                 ref.read(authStateProvider.notifier).logOut();
//               }
//             },
//             child: const Text('log out'),
//           ),
//         ],
//       ),
//       body: Center(
//         child: searchTerm.text.isEmpty
//             ? const Notes()
//             : SearchedNotes(searchTerm: searchTerm.text),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to the notes screen
//           GoRouter.of(context).go('/edit');
//         },
//         child: const Icon(CupertinoIcons.add),
//       ),
//     );
//   }
// }
