import 'package:flutter/material.dart';

Future<void> showAlertDialog(BuildContext context, String title, String content,
    String buttonText) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
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
            child: Text(
              buttonText,
              style: const TextStyle(color: Color(0xFF0081CF)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
