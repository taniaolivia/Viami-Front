import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/interestList.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/userInterest/usersInterests.dart';
import 'package:viami/services/userInterest/usersInterests.service.dart';

class InterestComponent extends StatefulWidget {
  final String page;
  final String userId;

  const InterestComponent({Key? key, required this.page, required this.userId})
      : super(key: key);

  @override
  State<InterestComponent> createState() => _InterestComponentState();
}

class _InterestComponentState extends State<InterestComponent> {
  final storage = const FlutterSecureStorage();

  String? token = "";

  int? userInterestsLength = 0;
  List<UserInterest>? userInterests = [];

  Future<UsersInterests> getAllInterests() async {
    token = await storage.read(key: "token");

    return UsersInterestsService()
        .getUserInterestsById(widget.userId, token.toString());
  }

  void initState() {
    getAllInterests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Align(
            alignment: Alignment.topLeft,
            child: AutoSizeText(
              "Mes centres d'intérêt",
              minFontSize: 11,
              maxFontSize: 13,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
          widget.page == "edit"
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      FadePageRoute(page: const InterestList()),
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
              : Container(),
        ]),
        const SizedBox(height: 10),
        widget.page == "edit"
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    FadePageRoute(page: const InterestList()),
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
                        future: getAllInterests(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height));
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

                          var data = snapshot.data!;

                          userInterestsLength = data.userInterests.length;
                          userInterests = data.userInterests;

                          return data.userInterests.length != 0
                              ? Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 7.0,
                                  runSpacing: 7.0,
                                  children: List.generate(
                                      data.userInterests.length, (index) {
                                    return Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        constraints: const BoxConstraints(
                                            maxWidth: double.infinity),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color(0xFF0081CF)),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: AutoSizeText(
                                          data.userInterests[index].interest,
                                          style: const TextStyle(
                                            color: Color(0xFF0081CF),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          minFontSize: 10,
                                          maxFontSize: 12,
                                        ));
                                  }).toList())
                              : Container(height: 80);
                        })))
            : Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(
                    minHeight: 45, maxHeight: double.infinity),
                child: FutureBuilder<UsersInterests>(
                    future: getAllInterests(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height));
                      }

                      if (snapshot.hasError) {
                        return Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                        );
                      }

                      if (!snapshot.hasData) {
                        return Text("");
                      }
                      var data = snapshot.data!;

                      userInterestsLength = data.userInterests.length;
                      userInterests = data.userInterests;

                      return data.userInterests.length != 0
                          ? Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 7.0,
                              runSpacing: 7.0,
                              children: List.generate(data.userInterests.length,
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
                                      data.userInterests[index].interest,
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
                                "Aucun intérêt",
                                minFontSize: 11,
                                maxFontSize: 13,
                              ));
                    })),
        userInterestsLength != 0
            ? const SizedBox(height: 30)
            : const SizedBox(height: 10),
      ],
    );
  }
}
