import 'package:flutter/foundation.dart';
import 'package:note_taking_app/widgets/dialogs/custom_alert_dialog.dart';

@immutable
class LogoutDialog extends CustomAlertDialog<bool> {
  const LogoutDialog()
      : super(
            title: 'Logout',
            message: 'Are you sure you want to Logout?',
            buttons: const {
              'Yes!': true,
              'Cancel': false,
            });
}
