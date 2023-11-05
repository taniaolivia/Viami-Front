import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../components/activity_card.dart';
import '../models/activity.dart';
import '../widgets/expandable_text_widget.dart';
import '../widgets/icon_and_text_widget.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({Key? key}) : super(key: key);

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  int selectedImage = 0;
  List<String> productImages = [
    '${dotenv.env['CDN_URL']}/assets/profil.png',
    '${dotenv.env['CDN_URL']}/assets/logo.png',
    '${dotenv.env['CDN_URL']}/assets/menu.png',
    // Add other image paths here
  ];
  List<Activity> activities = [
    Activity(
      image: '${dotenv.env['CDN_URL']}/assets/profil.png',
      name: 'Excursion en montagne',
      location: 'Montagnes ',
    ),
    Activity(
      image: '${dotenv.env['CDN_URL']}/assets/profil.png',
      name: 'Plongée sous-marine',
      location: 'Plages ',
    ),
    Activity(
      image: '${dotenv.env['CDN_URL']}/assets/profil.png',
      name: 'Excursion en montagne',
      location: 'Montagnes ',
    ),
    Activity(
      image: '${dotenv.env['CDN_URL']}/assets/profil.png',
      name: 'Excursion en montagne',
      location: 'Montagnes ',
    ),
    Activity(
      image: '${dotenv.env['CDN_URL']}/assets/profil.png',
      name: 'Excursion en montagne',
      location: 'Montagnes ',
    ),
    Activity(
      image: '${dotenv.env['CDN_URL']}/assets/profil.png',
      name: 'Excursion en montagne',
      location: 'Montagnes ',
    ),
    // Ajoutez d'autres activités ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: PageView.builder(
                        itemCount: productImages.length,
                        controller: PageController(viewportFraction: 1.0),
                        onPageChanged: (int index) {
                          setState(() {
                            selectedImage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(productImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    productImages.length,
                                    (index) => buildDot(index: index),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
                ],
              ),
              Container(
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
                          subtext: "subText",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ExpandableTextWidget(
                      text:
                          "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhjjjjjjhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const AutoSizeText(
                          "Activités proposées",
                          style: TextStyle(
                            color: Color(0xFF0A2753),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                          ),
                          minFontSize: 25,
                          maxFontSize: 28,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Container(
                      height: 350,
                      child: ListView.builder(
                          itemCount: activities.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 15),
                              child: Row(
                                children: [
                                  ActivityCard(activity: activities[index]),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 8,
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

  Widget buildDot({required int index}) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: selectedImage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
