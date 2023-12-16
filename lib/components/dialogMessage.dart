import 'package:flutter/material.dart';

Future<void> showDialogMessage(BuildContext context, String title,
    Widget content, Widget button, Widget? button2) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        alignment: Alignment.center,
        titleTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold),
        titlePadding: const EdgeInsets.only(left: 25, top: 40, bottom: 20),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[content],
          ),
        ),
        actions: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [button, button2!])
        ],
      );
    },
  );
}
