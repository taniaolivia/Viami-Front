import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:viami/components/introductionTemplate.dart';
import 'package:viami/screens/start.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  int page = 1;
  String image = "";
  String text1 = "";
  String text2 = "";
  double percent = 0.0;

  @override
  Widget build(BuildContext context) {
    if (page == 1) {
      image = "assets/introduction/intro1.png";
      text1 = "Tu ne veux pas voyager seul ?";
      text2 = "Par obligation ou par choix";
      percent = 0.3;
    } else if (page == 2) {
      image = "assets/introduction/intro2.png";
      text1 = "Rencontre des voyageurs seuls";
      text2 = "Discute et apprends à les connaître";
      percent = 0.6;
    } else if (page == 3) {
      image = "assets/introduction/intro3.png";
      text1 = "Voyage avec de nouveaux amis";
      text2 = "Part découvrir le monde avec tes nouveaux amis";
      percent = 1.0;
    }

    return Scaffold(
        body: SwipeTo(
      child: IntroductionTemplate(
          imageHeight: 1.7,
          containerHeight: 2.2,
          image: image,
          content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AutoSizeText(
                  text1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  minFontSize: 25,
                  maxFontSize: 30,
                ),
                const SizedBox(height: 20),
                AutoSizeText(
                  text2,
                  textAlign: TextAlign.center,
                  minFontSize: 15,
                  maxFontSize: 20,
                ),
                const SizedBox(height: 30),
                LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width / 2.5,
                    lineHeight: 8,
                    percent: percent,
                    progressColor: const Color(0xFF0081CF),
                    barRadius: const Radius.circular(10),
                    alignment: MainAxisAlignment.center)
              ])),
      onRightSwipe: () {
        setState(() {
          if (page > 1 && page <= 3) {
            page--;
          } else {
            page = 1;
          }
        });
      },
      onLeftSwipe: () {
        setState(() {
          if (page >= 1 && page < 3) {
            page++;
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StartPage()),
            );
          }
        });
      },
    ));
  }
}
