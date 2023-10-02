import 'package:flutter/material.dart';

class IntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.loose,
            children: <Widget> [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.28,
                child: const Image(
                  image: AssetImage("assets/introduction/intro1.png"), 
                  fit: BoxFit.fitWidth
                )
              ),
              Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/1.8),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      const Text(
                        "Tu ne veux pas voyager seul ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Par obligation ou par choix",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13
                        )
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {}, 
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF0081CF),
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0)
                        ), 
                        child: const Text(
                          "SUIVANT",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,

                          )
                        ),
                      )
                  ],) 
              )
            ],
          )
        ],
      )
    
    );
  }
}