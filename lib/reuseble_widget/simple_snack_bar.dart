import 'package:flutter/material.dart';

void showSnackBar(
    BuildContext context, String labelText, SnackBarType snackBarType) {
  Text? textItem;

  switch (snackBarType) {
    case SnackBarType.success:
      textItem = Text(
        labelText,
        style: TextStyle(color: Colors.green),
      );
      break;
    case SnackBarType.error:
      textItem = Text(
        labelText,
        style: TextStyle(color: Colors.red),
      );
      break;
    case SnackBarType.warning:
      textItem = Text(
        labelText,
        style: TextStyle(color: Colors.orange),
      );
      break;
    default:
      break;
  }

  final snackBar = SnackBar(content: textItem!);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

enum SnackBarType { success, error, warning, message }
