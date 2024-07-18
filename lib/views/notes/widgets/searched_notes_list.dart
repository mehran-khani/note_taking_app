import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/note/providers/notes_by_search_term_provider.dart';
import 'package:note_taking_app/views/animations/empty_animation.dart';
import 'package:note_taking_app/views/animations/error_animation.dart';
import 'package:note_taking_app/views/animations/loading_animation.dart';
import 'package:note_taking_app/views/notes/widgets/notes_grid_view.dart';

class SearchedNotes extends ConsumerWidget {
  final String? searchTerm;
  const SearchedNotes({
    super.key,
    required this.searchTerm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesBySearchTermProvider(searchTerm));

    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(notesBySearchTermProvider(searchTerm));
        return Future.delayed(const Duration(seconds: 1));
      },
      child: notes.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const EmptyAnimationView();
          } else {
            return NotesGridView(notes: notes);
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
