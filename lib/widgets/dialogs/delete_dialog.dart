import 'package:flutter/foundation.dart';
import 'package:note_taking_app/widgets/dialogs/custom_alert_dialog.dart';

@immutable
class DeleteDialog extends CustomAlertDialog<bool> {
  const DeleteDialog()
      : super(
            title: 'Delete Note',
            message: 'Are you sure you want to delete this note?',
            buttons: const {
              'Delete': true,
              'Cancel': false,
            });
}
