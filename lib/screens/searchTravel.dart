import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/generalTemplate.dart';
import 'package:viami/models-api/travel/travels.dart';
import 'package:viami/screens/travels.dart';
import 'package:viami/services/travel/travels.service.dart';

class SearchTravelPage extends StatefulWidget {
  const SearchTravelPage({Key? key}) : super(key: key);

  @override
  State<SearchTravelPage> createState() => _SearchTravelPageState();
}

class _SearchTravelPageState extends State<SearchTravelPage> {
  final storage = const FlutterSecureStorage();
  String? token;
  String? selectedLocation;
  List locationList = [];

  Future<Travels> getListTravels() {
    Future<Travels> getAllTravels() async {
      token = await storage.read(key: "token");

      return TravelsService().getAllTravels(token.toString());
    }

    return getAllTravels();
  }

  @override
  void initState() {
    super.initState();
    getListTravels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GeneralTemplate(
          image: "${dotenv.env['CDN_URL']}/assets/travels.jpg",
          imageHeight: MediaQuery.of(context).size.width <= 320 ? 3 : 1.5,
          content: Column(
            children: [
              Wrap(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  const SizedBox(width: 20),
                  FutureBuilder<Travels>(
                      future: getListTravels(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          //return Text("");
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (!snapshot.hasData) {
                          return Text('');
                        }

                        var travel = snapshot.data!;

                        for (int i = 0; i < travel.travels.length; i++) {
                          if (!locationList
                              .contains(travel.travels[i].location)) {
                            locationList.add(travel.travels[i].location);
                          }
                        }

                        return DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width / 1.5,
                          menuHeight: 200,
                          hintText: "Localisation*",
                          onSelected: (String? value) {
                            setState(() {
                              selectedLocation = value!;
                            });
                          },
                          dropdownMenuEntries: locationList
                              .map<DropdownMenuEntry<String>>((value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        );
                      })
                ]),
              ]),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    backgroundColor: const Color(0xFF0081CF),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                child: const AutoSizeText(
                  "Valider",
                  maxLines: 1,
                  minFontSize: 11,
                  maxFontSize: 13,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontFamily: "Poppins"),
                ),
                onPressed: () async {
                  var travels = await TravelsService()
                      .searchTravels(token!, selectedLocation!);

                  if (travels != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TravelsPage(travels: travels)));
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
          contentHeight: MediaQuery.of(context).size.width <= 320 ? 2.2 : 1.6,
          containerHeight: MediaQuery.of(context).size.width <= 320 ? 1.7 : 2.5,
          title: "Recherche",
          redirect: "/home",
        ));
  }
}
