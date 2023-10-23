import 'package:flutter/material.dart';
import 'package:viami/components/liquidSwipeAnimation.dart';
import 'package:viami/models/introduction_item.dart';
import 'package:viami/screens/start.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    List<IntroductionItem> data = [
      IntroductionItem(
          "assets/introduction/intro1.png",
          "Tu ne veux pas voyager seul ?",
          "Par obligation ou par choix",
          0.3,
          const Color(0xFFFFF3F0)),
      IntroductionItem(
          "assets/introduction/intro2.png",
          "Rencontre des voyageurs seuls",
          "Discute et apprends à les connaître",
          0.6,
          const Color(0xFFDFFCDE)),
      IntroductionItem(
          "assets/introduction/intro3.png",
          "Voyage avec de nouveaux amis",
          "Part découvrir le monde avec tes nouveaux amis",
          1.0,
          const Color(0xFFFFF4E4)),
      IntroductionItem("", "", "", 1.0, const Color(0xFF0081CF))
    ];

    return Scaffold(
      body: Stack(children: <Widget>[
        LiquidSwipeAnimation(
          page: page,
          data: data,
          redirect: const StartPage(),
        ),
      ]),
    );
  }
}
