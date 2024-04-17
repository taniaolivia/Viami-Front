import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/languageList.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/userLanguage/usersLanguages.dart';
import 'package:viami/services/userLanguage/usersLanguages.service.dart';

class LanguageComponent extends StatefulWidget {
  final String page;
  final String userId;

  const LanguageComponent({Key? key, required this.page, required this.userId})
      : super(key: key);

  @override
  State<LanguageComponent> createState() => _LanguageComponentState();
}

class _LanguageComponentState extends State<LanguageComponent> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  int? userLanguagesLength = 0;
  List<UserLanguage>? userLanguages = [];

  Future<UsersLanguages> getAllLanguages() async {
    token = await storage.read(key: "token");

    return UsersLanguagesService()
        .getUserLanguagesById(widget.userId, token.toString());
  }

  void initState() {
    getAllLanguages();
    setState(() {
      userLanguagesLength = userLanguagesLength;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "Les langues que je maîtrise",
            minFontSize: 11,
            maxFontSize: 13,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        widget.page == "edit"
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    FadePageRoute(page: const LanguageList()),
                  );
                },
                child: Container(
                    child: const AutoSizeText(
                  "< Ajouter",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                  minFontSize: 11,
                  maxFontSize: 13,
                  textAlign: TextAlign.right,
                )))
            : Container()
      ]),
      const SizedBox(height: 10),
      widget.page == "edit"
          ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const LanguageList()),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(
                    minHeight: 45, maxHeight: double.infinity),
                decoration: const BoxDecoration(
                    color: Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: FutureBuilder<UsersLanguages>(
                    future: getAllLanguages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height));
                      }

                      if (snapshot.hasError) {
                        return const Text(
                          '',
                          textAlign: TextAlign.center,
                        );
                      }

                      if (!snapshot.hasData) {
                        return Text('');
                      }

                      var data = snapshot.data!;

                      userLanguagesLength = data.userLanguages.length;
                      userLanguages = data.userLanguages;

                      return data.userLanguages.length != 0
                          ? Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 7.0,
                              runSpacing: 7.0,
                              children: List.generate(data.userLanguages.length,
                                  (index) {
                                return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    constraints: const BoxConstraints(
                                        maxWidth: double.infinity),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xFF0081CF)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: AutoSizeText(
                                      data.userLanguages[index].language,
                                      style: const TextStyle(
                                        color: Color(0xFF0081CF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      minFontSize: 10,
                                      maxFontSize: 12,
                                    ));
                              }).toList())
                          : Container(height: 80);
                    }),
              ))
          : Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(
                  minHeight: 45, maxHeight: double.infinity),
              child: FutureBuilder<UsersLanguages>(
                  future: getAllLanguages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        '',
                        textAlign: TextAlign.center,
                      );
                    } else if (!snapshot.hasData) {
                      return const Text('');
                    }

                    var data = snapshot.data!;

                    userLanguagesLength = data.userLanguages.length;
                    userLanguages = data.userLanguages;

                    return data.userLanguages.length != 0
                        ? Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 7.0,
                            runSpacing: 7.0,
                            children: List.generate(data.userLanguages.length,
                                (index) {
                              return Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  constraints: const BoxConstraints(
                                      maxWidth: double.infinity),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color(0xFF0081CF)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: AutoSizeText(
                                    data.userLanguages[index].language,
                                    style: const TextStyle(
                                      color: Color(0xFF0081CF),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    minFontSize: 10,
                                    maxFontSize: 12,
                                  ));
                            }).toList())
                        : Container(
                            height: 10,
                            child: const AutoSizeText(
                              "Aucune langue",
                              minFontSize: 11,
                              maxFontSize: 13,
                            ));
                  }),
            ),
      userLanguagesLength != 0
          ? const SizedBox(height: 40)
          : const SizedBox(height: 10)
    ]);
  }
}
