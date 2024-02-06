import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/snackBar.dart';
import 'package:viami/models-api/language/languages.dart';
import 'package:viami/models-api/userLanguage/usersLanguages.dart';
import 'package:viami/services/language/languages.service.dart';
import 'package:viami/services/userLanguage/userLanguage.service.dart';
import 'package:viami/services/userLanguage/usersLanguages.service.dart';

class LanguageList extends StatefulWidget {
  const LanguageList({Key? key}) : super(key: key);

  @override
  State<LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  List<bool> isCheckedList = [];
  List<String> languageList = [];
  List<int> languageIndex = [];
  ColorFilter? newColor;
  int? userLanguageLength;

  Future<Languages> getLanguages() {
    Future<Languages> getAllLanguages() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return LanguagesService().getAllLanguages(token.toString());
    }

    return getAllLanguages();
  }

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
    userLanguageLength = userLanguageLength;
    getUserLanguages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const AutoSizeText(
            "Langues",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            minFontSize: 18,
            maxFontSize: 20,
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              )),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                child: Column(children: <Widget>[
                  const AutoSizeText(
                    "Choisissez cinq langues que vous maîtrisez le plus.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    minFontSize: 10,
                    maxFontSize: 12,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const AutoSizeText(
                    "INFORMATION : Cliquez deux fois sur l'image que vous voulez supprimer dans votre liste de langues.",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    minFontSize: 10,
                    maxFontSize: 12,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                      future: Future.wait([getLanguages(), getUserLanguages()]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("");
                        }

                        if (snapshot.hasError) {
                          return Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                          );
                        }

                        if (!snapshot.hasData) {
                          return Text('');
                        }

                        var language = snapshot.data![0] as Languages;
                        var data = snapshot.data![1] as UsersLanguages;

                        languageList =
                            List.generate(language.languages.length, (index) {
                          return language.languages[index].language;
                        });

                        isCheckedList = List.generate(
                            language.languages.length, (index) => false);

                        userLanguageLength = data.userLanguages.length;

                        for (int i = 0; i < data.userLanguages.length; i++) {
                          if (languageList
                              .contains(data.userLanguages[i].language)) {
                            if (!languageIndex.contains(languageList
                                .indexOf(data.userLanguages[i].language))) {
                              languageIndex.add(languageList
                                  .indexOf(data.userLanguages[i].language));
                            }
                          }
                        }

                        return Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: List.generate(language.languages.length,
                                (index) {
                              if (languageIndex.contains(index)) {
                                isCheckedList[index] = true;
                              }

                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    if (languageIndex.contains(index)) {
                                      languageIndex.remove(index);
                                      isCheckedList[index] = false;
                                    } else {
                                      languageIndex.add(index);
                                      isCheckedList[index] = true;
                                    }
                                  });

                                  if (isCheckedList[index] == true) {
                                    if (languageIndex.length < 6) {
                                      await UserLanguageService()
                                          .addUserLanguage(
                                              userId!,
                                              language.languages[index].id!,
                                              token!);
                                    } else {
                                      languageIndex.remove(index);
                                      isCheckedList[index] = false;
                                      showSnackbar(
                                          context,
                                          "Vous avez dépassé la limite ! Vous ne pouvez que choisir cinq au maximum.",
                                          "D'accord",
                                          "");
                                    }
                                  } else {
                                    await UserLanguageService()
                                        .deleteUserLanguage(
                                            userId!,
                                            language.languages[index].id!,
                                            token!);
                                  }
                                },
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.7,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            colorFilter: isCheckedList[index]
                                                ? ColorFilter.mode(
                                                    const Color(0xFFFFDAA2)
                                                        .withOpacity(0.5),
                                                    BlendMode.dstATop)
                                                : null,
                                            image: NetworkImage(
                                                "${dotenv.env['CDN_URL']}/assets/language/${language.languages[index].imageName}"))),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              color:
                                                  isCheckedList[index] == true
                                                      ? const Color(0xFFFFDAA2)
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            child: AutoSizeText(
                                              language
                                                  .languages[index].language,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              minFontSize: 7,
                                              maxFontSize: 12,
                                              textAlign: TextAlign.center,
                                            )))),
                              );
                            }).toList());
                      }),
                  const SizedBox(height: 20),
                ]))),
        floatingActionButton: Container(
            height: 40.0,
            width: 140.0,
            child: FloatingActionButton(
                backgroundColor: const Color(0xFF0081CF),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  Navigator.pushNamed(context, "/profile");
                },
                child: const AutoSizeText(
                  "Sauvegarder",
                  minFontSize: 11,
                  maxFontSize: 13,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold),
                ))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
