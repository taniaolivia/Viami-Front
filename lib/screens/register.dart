import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:viami/components/generalTemplate.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int page = 1;
  String image = "";
  String text1 = "";
  String text2 = ""; 


  @override
  Widget build(BuildContext context) {

    if(page == 1) {
        image = "assets/logo.png";
        text1 = "Tu ne veux pas voyager seul ?";
        text2 = "Par obligation ou par choix";
    }
    else {
      image = "";
      text1 = "Tu ne veux pas voyager seul ?";
      text2 = "Par obligation ou par choix";
    }

    return Scaffold(
      body: GeneralTemplate(
            imageHeight: 2,
            containerHeight: 2,
            image: image,
            content: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 17 , 25, MediaQuery.of(context).size.width / 17 , 25),
                          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width / 2.35),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                          )
                        ),
                        onPressed: () {},
                        child: Column(children: <Widget> [
                            const AutoSizeText(
                              "S'inscrire",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                              maxLines: 1,
                              minFontSize: 17,
                              maxFontSize: 22,
                            ),
                            const SizedBox(height: 10),
                            LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width / 6.5,
                                lineHeight: 6,
                                percent: 1,
                                progressColor: const Color(0xFF0081CF),
                                barRadius: const Radius.circular(10),
                                alignment: MainAxisAlignment.center
                            )
                        ])
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 15 , 25, MediaQuery.of(context).size.width / 15 , 25),
                          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width / 2.35),
                          side: const BorderSide(
                            color: Colors.white
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                          )
                        ),
                        onPressed: () {},
                        child: 
                          Column(children: <Widget> [
                            const AutoSizeText(
                              "Se connecter",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                              maxLines: 1,
                              minFontSize: 17,
                              maxFontSize: 22,
                              overflow: TextOverflow.fade
                            ),
                            const SizedBox(height: 10),
                            LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width / 6.5,
                                lineHeight: 6,
                                percent: 1,
                                progressColor: const Color(0xFF0081CF),
                                barRadius: const Radius.circular(10),
                                alignment: MainAxisAlignment.center
                            )
                        ])
                      )
                    ]
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: const Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Email",
                              isDense: true,
                              contentPadding: EdgeInsets.all(12),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Mot de passe",
                              isDense: true,
                              contentPadding: EdgeInsets.all(12),  
                            ),
                          ),
                        ],
                      )
                    ), 
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 12, 40, 12),
                        backgroundColor: const Color(0xFF0081CF),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold)),
                    child: const AutoSizeText(
                      "Valider",
                      maxLines: 1,
                      minFontSize: 17,
                      maxFontSize: 22,
                      overflow: TextOverflow.fade
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20), 
                ],
          )),
        );
  }
}