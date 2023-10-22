import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/interestList.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userInterest/usersInterests.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userInterest/usersInterests.service.dart';

class InterestComponent extends StatelessWidget {
  InterestComponent({super.key});

  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  int? userInterestsLength = 0;
  List<UserInterest>? userInterests = [];

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
    return Column(
      children: <Widget>[
        const Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "Mes centres d'intérêt",
            minFontSize: 10,
            maxFontSize: 12,
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InterestList()),
              );
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(
                    minHeight: 45, maxHeight: double.infinity),
                decoration: const BoxDecoration(
                    color: Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: FutureBuilder<UsersInterests>(
                    future: getUserInterests(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!;

                        userInterestsLength = data.userInterests.length;
                        userInterests = data.userInterests;

                        return Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 0.0,
                            runSpacing: 0.0,
                            children: List.generate(data.userInterests.length,
                                (index) {
                              return Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  constraints: const BoxConstraints(
                                      maxWidth: double.infinity),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDAA2),
                                    border: Border.all(
                                        color: const Color(0xFFE85124)),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: AutoSizeText(
                                    data.userInterests[index].interest,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    minFontSize: 11,
                                    maxFontSize: 13,
                                  ));
                            }).toList());
                      }

                      return const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator());
                    }))),
        const SizedBox(height: 20),
      ],
    );
  }
}
