import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Utils {
  static Future<void> showAlertDialog(BuildContext context, {required String title,
      required String content, required String confirmText, required Function() onConfirm,
      String cancelText = "Cancel"}) async {
    Widget cancelButton() => TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        );
    Widget confirmButton() => TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop(true);
          },
          child: Text(confirmText),
        );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [cancelButton(), confirmButton()],
    );
    if (Platform.isIOS) {
      showCupertinoModalPopup(context: context, builder: (_) => alert);
    } else {
      showDialog(context: context, builder: (_) => alert);
    }
  }

  static void showErrorMessage(BuildContext context, String message) {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Something went wrong"),
            content: Text("Error: $message"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Something went wrong"),
            content: Text("Error: $message"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
