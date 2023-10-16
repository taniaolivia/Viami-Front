import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:viami/components/introductionTemplate.dart';

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
                Text(text1,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text(text2,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center),
                const SizedBox(height: 30),
                page == 3
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(40, 12, 40, 12),
                            backgroundColor: const Color(0xFF0081CF),
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        child: const Text("SUIVANT"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                      )
                    : const SizedBox(height: 20),
                page == 3
                    ? const SizedBox(height: 40)
                    : const SizedBox(height: 85),
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
            page = 3;
          }
        });
      },
    ));
  }
}
