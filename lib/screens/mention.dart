import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MentionPage extends StatefulWidget {
  const MentionPage({super.key});

  @override
  State<StatefulWidget> createState() => _MentionPage();
}

class _MentionPage extends State<MentionPage> {
  bool startAnimation = false;

  final List<String> items = [
    "Politique de confidentialité",
    "Conditions d'utilisation",
    "Supprimer le compte"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AutoSizeText(
            'Mentions légales',
            minFontSize: 16,
            maxFontSize: 18,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              )),
          backgroundColor: const Color(0xFF0081CF),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            const SizedBox(
              height: 15,
            ),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return item(index);
              },
            ),
          ]),
        )));
  }

  Widget item(int index) {
    return GestureDetector(
        onTap: () async {
          if (index == 0) {
            await launchUrl(Uri.parse(
                'https://viami-api.onrender.com/politique-de-confidentialite'));
          } else if (index == 1) {
            await launchUrl(Uri.parse(
                'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'));
          } else {
            await launchUrl(
                Uri.parse('https://viami-api.onrender.com/supprimer-compte'));
          }
        },
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
            child: Card(
                surfaceTintColor: Colors.white,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 55, 55, 55), width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    " ${items[index]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                ))));
  }
}
