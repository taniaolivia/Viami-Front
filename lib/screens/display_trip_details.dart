import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:viami/widgets/icon_and_text_widget.dart';

import '../models-api/travel/travel.dart';
import '../services/travel/travels.service.dart';
import '../services/travelImage/travelsImages.service.dart';
import '../widgets/expandable_text_widget.dart';

class DisplayTravelPage extends StatefulWidget {
  final String travelId;

  const DisplayTravelPage({Key? key, required this.travelId}) : super(key: key);

  @override
  State<DisplayTravelPage> createState() => _DisplayTravelPage();
}

class _DisplayTravelPage extends State<DisplayTravelPage> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? nbPeInt;
  List<String> travelImages = [];

  int selectedImage = 0;

  Future<Travel> getListTravelById() {
    Future<Travel> getAllTravel() async {
      token = await storage.read(key: "token");
      return TravelsService().getTravelById(widget.travelId, token.toString());
    }

    return getAllTravel();
  }

  Future<void> getTravelImages() async {
    token = await storage.read(key: "token");

    final images = await TravelsImagesService()
        .getTravelImagesById(widget.travelId, token.toString());

    setState(() {
      travelImages = images.travelImages.map((image) {
        return '${dotenv.env['CDN_URL']}/assets/${image.imageName}';
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await getTravelImages();
    await getListTravelById();
  }

  @override
  Widget build(BuildContext context) {
    Travel travel;

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
                    image: NetworkImage(travelImages[selectedImage]),
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
                  for (int i = 0; i < travelImages.length; i++)
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
                            image: NetworkImage(travelImages[i]),
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
                child: FutureBuilder<Travel>(
                  future: getListTravelById(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('No travel details available.');
                    }

                    travel = snapshot.data!;
                    nbPeInt = travel.nbPepInt?.toString() ?? "0";

                    return Container(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                              AutoSizeText(
                                travel.name,
                                style: const TextStyle(
                                  color: Color(0xFF0A2753),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
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
                            children: [
                              IconAndTextWidget(
                                icon: Icons.location_on,
                                text: travel.location,
                                color: Colors.black,
                                iconColor: Color(0xFF0081CF),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconAndTextWidget(
                                icon: Icons.person,
                                text: travel.nbPepInt?.toString() ?? "0",
                                color: Colors.black,
                                iconColor: Colors.blue,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ExpandableTextWidget(
                            text: travel.description,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Expanded(
            child: Container(
                height: 50.0,
                width: 250.00,
                child: FloatingActionButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    onPressed: () {
                      Navigator.pushNamed(context, "/profile");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          "${nbPeInt} personnes intéressés",
                          minFontSize: 11,
                          maxFontSize: 13,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
