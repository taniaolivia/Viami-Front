import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/components/liquidSwipeAnimation.dart';
import 'package:viami/models/introduction_item.dart';
import 'package:viami/screens/login.dart';

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
          "${dotenv.env['CDN_URL']}/assets/viami-world.gif",
          "Vous ne voulez pas voyager seul ?",
          "Par obligation ou par choix",
          0.3,
          const Color(0xFF0081CF)),
      IntroductionItem(
          "${dotenv.env['CDN_URL']}/assets/viami-world.gif",
          "Rencontrez des voyageurs seuls",
          "Discutez et apprends à les connaître",
          0.6,
          const Color(0xFF0081CF)),
      IntroductionItem(
          "${dotenv.env['CDN_URL']}/assets/viami-world.gif",
          "Voyagez avec de nouveaux amis",
          "Partez découvrir le monde avec vos nouveaux amis",
          1.0,
          const Color(0xFF0081CF)),
      IntroductionItem("", "", "", 1.0, const Color(0xFF0081CF))
    ];

    return Scaffold(
      body: Stack(children: <Widget>[
        LiquidSwipeAnimation(
          page: page,
          data: data,
          redirect: const LoginPage(),
        ),
      ]),
    );
  }
}
