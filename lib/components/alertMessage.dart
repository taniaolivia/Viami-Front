import 'package:flutter/material.dart';

Future<void> showAlertDialog(BuildContext context, String title, String content,
    String buttonText) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        backgroundColor: const Color(0xFFF5C7BD),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                content,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(buttonText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
