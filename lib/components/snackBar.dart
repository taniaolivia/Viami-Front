import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message, String buttonText,
    String redirectAction) {
  final snackBar = SnackBar(
    padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
    content: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Text(
          message,
        )),
    action: SnackBarAction(
      label: buttonText,
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
