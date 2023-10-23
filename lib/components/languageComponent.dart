import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/languageList.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userLanguage/usersLanguages.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userLanguage/usersLanguages.service.dart';

class LanguageComponent extends StatefulWidget {
  const LanguageComponent({Key? key}) : super(key: key);

  @override
  State<LanguageComponent> createState() => _LanguageComponentState();
}

class _LanguageComponentState extends State<LanguageComponent> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  int? userLanguagesLength = 0;
  List<UserLanguage>? userLanguages = [];

  Future<UsersLanguages> getUserLanguages() {
    Future<UsersLanguages> getAllLanguages() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UsersLanguagesService()
          .getUserLanguagesById(userId.toString(), token.toString());
    }

    return getAllLanguages();
  }

  void initState() {
    setState(() {
      userLanguagesLength = userLanguagesLength;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(children: [
        const Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "Mes langues",
            minFontSize: 11,
            maxFontSize: 13,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguageList()),
              );
            },
            child: Container(
                width: MediaQuery.of(context).size.width / 1.55,
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
      ]),
      const SizedBox(height: 10),
      GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LanguageList()),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            constraints:
                const BoxConstraints(minHeight: 45, maxHeight: double.infinity),
            decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: FutureBuilder<UsersLanguages>(
                future: getUserLanguages(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!;

                    userLanguagesLength = data.userLanguages.length;
                    userLanguages = data.userLanguages;

                    return Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 0.0,
                        runSpacing: 0.0,
                        children:
                            List.generate(data.userLanguages.length, (index) {
                          return Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              constraints: const BoxConstraints(
                                  maxWidth: double.infinity),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDFFCDE),
                                border:
                                    Border.all(color: const Color(0xFF00611B)),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: AutoSizeText(
                                data.userLanguages[index].language,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                minFontSize: 10,
                                maxFontSize: 12,
                              ));
                        }).toList());
                  }

                  return const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
                }),
          )),
      const SizedBox(height: 40)
    ]);
  }
}
