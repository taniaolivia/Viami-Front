import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/services/faq/faqs.service.dart';

import '../models-api/faqs/faqData.dart';
import '../models-api/faqs/faqDatas.dart';

class FaqDetailsPage extends StatefulWidget {
  const FaqDetailsPage({super.key});

  @override
  State<FaqDetailsPage> createState() => _FaqDetailsPageState();
}

class _FaqDetailsPageState extends State<FaqDetailsPage> {
  String? token = "";
  final storage = const FlutterSecureStorage();
  final _formKeySearchName = GlobalKey<FormState>();
  TextEditingController searchControllerName = TextEditingController();

  late Faqs faqs;
  late Future<Faqs?> all;
  Faqs? allFaqs;

  Future<void> getDisplayFaqs() async {
    token = await storage.read(key: "token");
    allFaqs = await FaqsService().getAllFaq(token.toString());

    if (mounted) {
      setState(() {});
    }
  }

  Future<Faqs> getAllFrqFaqs() {
    Future<Faqs> getFFaqs() async {
      token = await storage.read(key: "token");
      return FaqsService().getTopFiveFrequentedFaq(token.toString());
    }

    return getFFaqs();
  }

  bool startAnimation = false;
  @override
  void initState() {
    super.initState();
    getDisplayFaqs();
    getAllFrqFaqs();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            width: 50,
                            height: 50,
                            margin: MediaQuery.of(context).size.width <= 320
                                ? const EdgeInsets.fromLTRB(20, 20, 0, 0)
                                : const EdgeInsets.fromLTRB(20, 30, 0, 0),
                            padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  size: 20,
                                )))),
                    const AutoSizeText(
                      "FAQ",
                      minFontSize: 23,
                      maxFontSize: 25,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          shadows: [
                            BoxShadow(
                              color: Color.fromARGB(255, 174, 167, 167),
                              blurRadius: 20.0,
                              spreadRadius: 5.0,
                              offset: Offset(
                                0.0,
                                0.0,
                              ),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Barre de recherche
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.35,
                            child: Form(
                              key: _formKeySearchName,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez remplir votre quistion';
                                      }
                                      return null;
                                    },
                                    controller: searchControllerName,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 5, 10, 5),
                                      labelText: 'Recherche ',
                                      hintText: '',
                                      labelStyle: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0081CF),
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            onPressed: () async {
                              if (_formKeySearchName.currentState!.validate()) {
                                var searchName = searchControllerName.text;

                                var faqSearch = await FaqsService()
                                    .searchFaqByKeyword(token!, searchName);

                                if (faqSearch != null) {
                                  setState(() {
                                    allFaqs = faqSearch;
                                  });
                                }

                                FocusScope.of(context).unfocus();
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () async {
                            var clearName =
                                await FaqsService().getAllFaq(token.toString());

                            setState(() {
                              allFaqs = clearName;
                              searchControllerName.text = "";
                            });

                            FocusScope.of(context).unfocus();
                          },
                          child: const AutoSizeText(
                            "Réinitialiser",
                            minFontSize: 10,
                            maxFontSize: 12,
                            style: TextStyle(color: Color(0xFF0081CF)),
                          ),
                        ),
                      ),
                    ),
                  ])),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        "Questions fréquentes",
                        minFontSize: 18,
                        maxFontSize: 20,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ))),
              Container(
                height: 250,
                child: FutureBuilder<Faqs>(
                    future: getAllFrqFaqs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height));
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('');
                      }

                      faqs = snapshot.data!;

                      return ListView.builder(
                          itemCount: faqs.faqs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final faq = faqs.faqs[index];

                            return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 15, top: 20, bottom: 20),
                                child: Row(children: [
                                  GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              surfaceTintColor: Colors.white,
                                              title: Text(
                                                  toBeginningOfSentenceCase(
                                                      faq.question)!),
                                              titleTextStyle: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Poppins"),
                                              content: Text(faq.answer),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Fermer',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              border: Border.all(
                                                width: 2,
                                                color: const Color(0xFFDADADA),
                                              ),
                                              color: const Color(0xFFEDEEEF),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 10.0,
                                                  spreadRadius: 3.0,
                                                  offset: Offset(
                                                    5.0,
                                                    5.0,
                                                  ),
                                                )
                                              ]),
                                          child: Column(children: [
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.language,
                                                          size: 20,
                                                          color:
                                                              Color(0xFF0081CF),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                      ]),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                ]),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    AutoSizeText(
                                                        toBeginningOfSentenceCase(
                                                            faq.question)!,
                                                        minFontSize: 12,
                                                        maxFontSize: 14,
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF0A2753))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            surfaceTintColor:
                                                                Colors.white,
                                                            title: Text(
                                                                toBeginningOfSentenceCase(
                                                                    faq.question)!),
                                                            titleTextStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            content: Text(
                                                                faq.answer),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: const Text(
                                                                    'Fermer',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black)),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_forward,
                                                      size: 20,
                                                      color: Color(0xFF0081CF),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ])
                                          ]))),
                                  const SizedBox(
                                    height: 40,
                                  )
                                ]));
                          });
                    }),
              ),
              const SizedBox(
                height: 40,
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        "Nos articles",
                        minFontSize: 18,
                        maxFontSize: 20,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ))),
              const SizedBox(
                height: 20,
              ),
              if (allFaqs?.faqs.isEmpty ?? true) Text('Aucun Faq trouvé'),
              if (!(allFaqs?.faqs.isEmpty ?? true))
                Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            List.generate(allFaqs?.faqs.length ?? 0, (index) {
                          var allFaq = allFaqs?.faqs[index];
                          return item(allFaq!, index);
                        }),
                      ),
                    )),
            ],
          ),
        )));
  }

  Widget item(Faq faq, int index) {
    return GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
            height: 65,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300 + (index * 100)),
            transform: Matrix4.translationValues(
                startAnimation ? 0 : MediaQuery.of(context).size.width, 0, 0),
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 40,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(137, 248, 244, 244),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        surfaceTintColor: Colors.white,
                        title: Text(toBeginningOfSentenceCase(faq.question)!),
                        titleTextStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins"),
                        content: Text(faq.answer),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Fermer',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                    child: ListTile(
                  tileColor: const Color.fromARGB(255, 238, 244, 249),
                  title: AutoSizeText(
                    faq.question,
                    minFontSize: 12,
                    maxFontSize: 14,
                    style: const TextStyle(color: Colors.black),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                Text(toBeginningOfSentenceCase(faq.question)!),
                            content: Text(faq.answer),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Fermer'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: Color(0xFF0081CF),
                    ),
                  ),
                )))));
  }
}
