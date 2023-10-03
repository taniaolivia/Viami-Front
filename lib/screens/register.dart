import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:viami/components/generalTemplate.dart';

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
                          padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width / 2.23),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                          )
                        ),
                        onPressed: () {},
                        child: Column(children: <Widget> [
                            const Text(
                              "S'inscrire",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
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
                          padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width / 2.23),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                          )
                        ),
                        onPressed: () {},
                        child: Column(children: <Widget> [
                            const Text(
                              "Se connecter",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
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
                              labelText: "Email"
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Mot de passe"
                            ),
                          ),
                        ],
                      )
                    ), 
                  )  
                ],
            
          )),
        );
  }
}