import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/interest/interests.dart';
import 'package:viami/models-api/userInterest/usersInterests.dart';
import 'package:viami/services/interest/interests.service.dart';
import 'package:viami/services/userInterest/userInterest.service.dart';
import 'package:viami/services/userInterest/usersInterests.service.dart';

class InterestList extends StatefulWidget {
  const InterestList({Key? key}) : super(key: key);

  @override
  State<InterestList> createState() => _InterestListState();
}

class _InterestListState extends State<InterestList> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  List<bool> isCheckedList = [];
  List<String> interestList = [];
  List<int> interestIndex = [];
  ColorFilter? newColor;

  Future<Interests> getInterests() {
    Future<Interests> getAllInterests() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return InterestsService().getAllInterests(token.toString());
    }

    return getAllInterests();
  }

  Future<UsersInterests> getUserInterests() {
    Future<UsersInterests> getAllInterests() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UsersInterestsService()
          .getUserInterestsById(userId.toString(), token.toString());
    }

    return getAllInterests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
                child: Column(children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            )),
                        const Expanded(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
                                child: AutoSizeText(
                                  "Centres d'intérêt",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  minFontSize: 18,
                                  maxFontSize: 20,
                                  textAlign: TextAlign.center,
                                ))),
                      ]),
                  const SizedBox(height: 20),
                  const AutoSizeText(
                    "Choisissez cinq intérêts que vous aimez le plus.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    minFontSize: 10,
                    maxFontSize: 12,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const AutoSizeText(
                    "INFORMATION : Cliquez deux fois sur l'image que vous voulez supprimer dans vos centres d'intérêt.",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    minFontSize: 10,
                    maxFontSize: 12,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                      future: Future.wait([getInterests(), getUserInterests()]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var interest = snapshot.data![0] as Interests;
                          var data = snapshot.data![1] as UsersInterests;

                          interestList =
                              List.generate(interest.interests.length, (index) {
                            return interest.interests[index].interest;
                          });

                          isCheckedList = List.generate(
                              interest.interests.length, (index) => false);

                          return Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: List.generate(interest.interests.length,
                                  (index) {
                                if (index < data.userInterests.length) {
                                  if (interestList.contains(
                                      data.userInterests[index].interest)) {
                                    if (!interestIndex.contains(
                                        interestList.indexOf(data
                                            .userInterests[index].interest))) {
                                      interestIndex.add(interestList.indexOf(
                                          data.userInterests[index].interest));
                                    }
                                  }
                                }

                                if (interestIndex.contains(index)) {
                                  isCheckedList[index] = true;
                                }

                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      if (interestIndex.contains(index)) {
                                        interestIndex.remove(index);
                                        isCheckedList[index] = false;
                                      } else {
                                        interestIndex.add(index);
                                        isCheckedList[index] = true;
                                      }
                                    });

                                    newColor = isCheckedList[index]
                                        ? ColorFilter.mode(
                                            const Color(0xFFFFDAA2)
                                                .withOpacity(0.5),
                                            BlendMode.dstATop)
                                        : null;

                                    if (isCheckedList[index] == true) {
                                      await UserInterestService()
                                          .addUserInterest(
                                              userId!,
                                              interest.interests[index].id!,
                                              token!);
                                    } else {
                                      await UserInterestService()
                                          .deleteUserInterest(
                                              userId!,
                                              interest.interests[index].id!,
                                              token!);
                                    }
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: isCheckedList[index]
                                                  ? ColorFilter.mode(
                                                      const Color(0xFFFFDAA2)
                                                          .withOpacity(0.5),
                                                      BlendMode.dstATop)
                                                  : null,
                                              image: AssetImage(
                                                  "assets/interest/${interest.interests[index].interest}.jpg"))),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                color: isCheckedList[index] ==
                                                        true
                                                    ? const Color(0xFFFFDAA2)
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              child: AutoSizeText(
                                                interest
                                                    .interests[index].interest,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                minFontSize: 11,
                                                maxFontSize: 13,
                                                textAlign: TextAlign.center,
                                              )))),
                                );
                              }).toList());
                        }

                        return const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator());
                      }),
                  const SizedBox(height: 20),
                ]))),
        floatingActionButton: Container(
            height: 40.0,
            width: 140.0,
            child: FloatingActionButton(
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
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
