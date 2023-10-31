import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/widgets/icon_and_text_widget.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/expandable_text_widget.dart';

class DisplayTravelPage extends StatefulWidget {
  const DisplayTravelPage({Key? key}) : super(key: key);

  @override
  State<DisplayTravelPage> createState() => _DisplayTravelPage();
}

class _DisplayTravelPage extends State<DisplayTravelPage> {
  List<String> productImages = [
    '${dotenv.env['CDN_URL']}/assets/profil.png',
    '${dotenv.env['CDN_URL']}/assets/logo.png',
    '${dotenv.env['CDN_URL']}/assets/menu.png',
    // Ajoutez d'autres chemins d'images ici
  ];
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double travelImageContainer = screenHeight / 2.41;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              width: double.maxFinite,
              height: travelImageContainer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(productImages[selectedImage]),
                ),
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 20,
            child: Container(
              width: 20,
              height: 20,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 30,
            child: Column(
              children: [
                for (int i = 0; i < productImages.length; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = i;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 6),
                      height: 51,
                      width: 51,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue
                              .withOpacity(i == selectedImage ? 1 : 0),
                          width: 2,
                        ),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(productImages[i]),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: travelImageContainer,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AutoSizeText(
                          "Nusa Pedina",
                          style: TextStyle(
                            color: Color(0xFF0A2753),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                          ),
                          minFontSize: 25,
                          maxFontSize: 28,
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 228, 241, 247),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.favorite,
                              color: Color(0xFF0081CF),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        IconAndTextWidget(
                          icon: Icons.location_on,
                          text: "Location",
                          color: Colors.black,
                          iconColor: Color(0xFF0081CF),
                          subtext: "subText",
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        IconAndTextWidget(
                            icon: Icons.person,
                            text: "Nombre personnes",
                            color: Colors.black,
                            iconColor: Colors.blue,
                            subtext: "subText"),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const ExpandableTextWidget(
                      text:
                          "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhjjjjjjhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: screenHeight / 8,
        padding:
            const EdgeInsets.only(top: 20, bottom: 30, left: 20, right: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Ajoutez ici les actions à effectuer lors du clic sur le bouton "Réserver"
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Couleur du texte
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("8 personnes interesses"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
