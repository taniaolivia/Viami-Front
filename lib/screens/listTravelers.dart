import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/services/userImage/usersImages.service.dart';
import 'package:viami/widgets/menu_widget.dart';

import 'drawer.dart';

class ListTravelersPage extends StatefulWidget {
  final List? users;
  const ListTravelersPage({Key? key, this.users}) : super(key: key);

  @override
  State<ListTravelersPage> createState() => _ListTravelersPageState();
}

class _ListTravelersPageState extends State<ListTravelersPage> {
  final storage = const FlutterSecureStorage();
  String? token;
  String userImages = "";
  String? userId = "";

  Future<UsersImages> getUsersImages(int index) async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return await UsersImagesService()
        .getUserImagesById(widget.users![index].userId, token.toString());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            )),
        backgroundColor: const Color(0xFF0081CF),
      ),
      backgroundColor: Colors.white,
      drawer: const DrawerPage(),
      body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(32, 20, 32, 50),
              child: Column(children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      'Voyageurs',
                      minFontSize: 23,
                      maxFontSize: 26,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      'Retrouvez les voyageurs cherchant un duo pour cette conversation',
                      minFontSize: 10,
                      maxFontSize: 12,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.7)),
                    )),
                const SizedBox(height: 20),
                Row(children: const [
                  Expanded(
                      child: Divider(
                    color: Color.fromARGB(255, 188, 186, 190),
                  )),
                  SizedBox(width: 10),
                  AutoSizeText(
                    "Aujourd'hui",
                    minFontSize: 10,
                    maxFontSize: 12,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 0.7)),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Divider(
                    color: Color.fromARGB(255, 188, 186, 190),
                  ))
                ]),
                const SizedBox(height: 20),
                Wrap(
                    direction: Axis.horizontal,
                    spacing: 10.0,
                    runSpacing: 20.0,
                    children: List.generate(widget.users!.length, (index) {
                      return FutureBuilder(
                          future: getUsersImages(index),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData) {
                              return const Text('');
                            }

                            var image = snapshot.data!;

                            return widget.users![index].userId != userId
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.6,
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              image.userImages[0].image),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, bottom: 10),
                                            child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: AutoSizeText(
                                                  "${toBeginningOfSentenceCase(widget.users![index].firstName)!}, ${widget.users![index].age}",
                                                  minFontSize: 16,
                                                  maxFontSize: 17,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      shadows: [
                                                        BoxShadow(
                                                          color: Colors.black,
                                                          blurRadius: 10.0,
                                                          spreadRadius: 5.0,
                                                          offset: Offset(
                                                            0.0,
                                                            0.0,
                                                          ),
                                                        )
                                                      ]),
                                                ))),
                                        Container(
                                            width: double.infinity,
                                            height: 40,
                                            child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            0, 0, 0, 0.5),
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20)))),
                                                child: const Icon(
                                                  Icons.message_rounded,
                                                  color: Color(0xFF0081CF),
                                                )))
                                      ],
                                    ))
                                : const SizedBox.shrink();
                          });
                    }).toList())
              ]))),
    );
  }
}
