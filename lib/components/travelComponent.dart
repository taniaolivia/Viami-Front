import 'package:flutter/src/widgets/framework.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/services/travelActivity/travelsActivities.service.dart';
import '../components/activity_card.dart';
import '../models-api/travel/travel.dart';
import '../models-api/travelActivity/travelsActivities.dart';
import '../services/travel/recommendedTravel.service.dart';
import '../services/travel/travels.service.dart';
import '../services/travelImage/travelsImages.service.dart';
import '../widgets/expandable_text_widget.dart';
import '../widgets/icon_and_text_widget.dart';

class TravelComponent extends StatefulWidget {
  final String travelId;
  final bool isRecommended;
  const TravelComponent(
      {Key? key, required this.travelId, required this.isRecommended})
      : super(key: key);

  @override
  State<TravelComponent> createState() => _TravelComponentState();
}

class _TravelComponentState extends State<TravelComponent> {
  int selectedImage = 0;
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? nbPeInt;

  List<String> travelImages = [];

  Future<Travel> getListTravelById() {
    Future<Travel> getAllTravel() async {
      token = await storage.read(key: "token");
      if (widget.isRecommended) {
        return RecommendedTravelsService()
            .getRecommendTravelById(widget.travelId, token.toString());
      } else {
        return TravelsService()
            .getTravelById(widget.travelId, token.toString());
      }
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
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    await getTravelImages();
    await getListTravelById();
  }

  @override
  Widget build(BuildContext context) {
    Future<TravelsActivities> getTravelActivities() {
      Future<TravelsActivities> getTravelActivitiesList() async {
        token = await storage.read(key: "token");
        return TravelsActivitiesService()
            .getTravelActivitiesById(widget.travelId, token.toString());
      }

      return getTravelActivitiesList();
    }

    Travel travel;
    TravelsActivities travelsActivities;
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
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: PageView.builder(
                          itemCount: travelImages.length,
                          controller: PageController(viewportFraction: 1.0),
                          onPageChanged: (int index) {
                            setState(() {
                              selectedImage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                image: DecorationImage(
                                  image:
                                      NetworkImage(travelImages[selectedImage]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      travelImages.length,
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
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: FutureBuilder<Travel>(
                        future: getListTravelById(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return const Text('No travel details available.');
                          }

                          travel = snapshot.data!;

                          if (travel.nbPepInt == null) {
                            nbPeInt = "0";
                          } else {
                            nbPeInt = travel.nbPepInt.toString();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color.fromARGB(255, 228, 241, 247),
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
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconAndTextWidget(
                                    icon: Icons.location_on,
                                    text: travel.location,
                                    color: Colors.black,
                                    iconColor: const Color(0xFF0081CF),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  AutoSizeText(
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
                                  child: FutureBuilder<TravelsActivities>(
                                      future: getTravelActivities(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else if (!snapshot.hasData) {
                                          return const Text(
                                              'No travel details available.');
                                        }

                                        travelsActivities = snapshot.data!;

                                        return ListView.builder(
                                            itemCount: travelsActivities
                                                .travelActivities.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final activity = travelsActivities
                                                  .travelActivities[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 15),
                                                child: Row(
                                                  children: [
                                                    ActivityCard(
                                                        activity: activity),
                                                  ],
                                                ),
                                              );
                                            });
                                      })),
                            ],
                          );
                        })),
              ],
            ),
          ),
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
                          "$nbPeInt personnes intéressées",
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

  Widget buildDot({required int index}) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: selectedImage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
