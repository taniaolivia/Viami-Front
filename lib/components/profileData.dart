import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/models-api/user/user.dart';

class ProfileData extends StatefulWidget {
  final User user;
  const ProfileData({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileData> createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  final storage = const FlutterSecureStorage();

  String? token = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "${toBeginningOfSentenceCase(widget.user.firstName)!}, ${widget.user.age}",
            minFontSize: 18,
            maxFontSize: 20,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
          )),
      const SizedBox(height: 30),
      const Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "Localisation",
            minFontSize: 11,
            maxFontSize: 13,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          )),
      const SizedBox(height: 10),
      Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            widget.user.location,
            minFontSize: 11,
            maxFontSize: 13,
            style: const TextStyle(
              color: Colors.black,
            ),
          )),
      const SizedBox(height: 30),
      const Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "À propos de moi",
            minFontSize: 11,
            maxFontSize: 13,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          )),
      const SizedBox(height: 10),
      Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            toBeginningOfSentenceCase(widget.user.description)!,
            minFontSize: 11,
            maxFontSize: 13,
            style: const TextStyle(
              color: Colors.black,
            ),
          )),
      const SizedBox(height: 30),
    ]);
  }
}
