import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

void showAlert(BuildContext context, QuickAlertType type, String text, {bool isDismissible = true}) {
    QuickAlert.show(
      context: context,
      type: type,
      text: text,
      barrierDismissible: isDismissible,
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
      },
    );
  }
