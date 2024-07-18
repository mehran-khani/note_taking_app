import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

@immutable
class CustomAlertDialog<T> {
  final String title;
  final String message;
  final Map<String, T> buttons;

  const CustomAlertDialog({
    required this.title,
    required this.message,
    required this.buttons,
  });
}

extension Present<T> on CustomAlertDialog<T> {
  Future<T?> present(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: buttons.entries.map(
            (entry) {
              return TextButton(
                onPressed: () {
                  GoRouter.of(context).pop(entry.value);
                },
                child: Text(entry.key),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
