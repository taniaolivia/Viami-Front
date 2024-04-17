import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color(0xFF0081CF),
            ),
            child: Column(children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/logo.png",
                        width: MediaQuery.of(context).size.width / 1.1,
                      ))),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0081CF),
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width / 20,
                              20,
                              MediaQuery.of(context).size.width / 20,
                              20),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width / 2.35),
                          side: const BorderSide(color: Colors.white),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      onPressed: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: const AutoSizeText("Se connecter",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          minFontSize: 11,
                          maxFontSize: 20,
                          overflow: TextOverflow.fade),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width / 20,
                              20,
                              MediaQuery.of(context).size.width / 20,
                              20),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width / 2.35),
                          side: const BorderSide(color: Colors.white),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: const AutoSizeText("S'inscrire",
                          style: TextStyle(
                              color: Color(0xFF0081CF),
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          minFontSize: 11,
                          maxFontSize: 20,
                          overflow: TextOverflow.fade),
                    ),
                  ],
                ),
              )),
              const SizedBox(
                height: 70,
              )
            ])));
  }
}
