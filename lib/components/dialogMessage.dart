import 'package:flutter/material.dart';

Future<void> showDialogMessage(
    BuildContext context, String title, Widget content, Widget button) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[content],
          ),
        ),
        actions: <Widget>[button],
      );
    },
  );
}
