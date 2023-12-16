import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/generalTemplate.dart';
import 'package:viami/models-api/travel/travels.dart';
import 'package:viami/screens/travelDetails.dart';
import 'package:viami/services/travel/travels.service.dart';

class SearchTravelPage extends StatefulWidget {
  const SearchTravelPage({Key? key}) : super(key: key);

  @override
  State<SearchTravelPage> createState() => _SearchTravelPageState();
}

class _SearchTravelPageState extends State<SearchTravelPage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  String? token;
  String? selectedLocation;
  List locationList = [""];
  String fillDestination = "";

  Future<Travels> getListTravels() {
    Future<Travels> getAllTravels() async {
      token = await storage.read(key: "token");

      return TravelsService().getAllTravels(token.toString());
    }

    return getAllTravels();
  }

  @override
  void initState() {
    fillDestination = "";
    getListTravels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GeneralTemplate(
          image: "${dotenv.env['CDN_URL']}/assets/travels.jpg",
          imageHeight: MediaQuery.of(context).size.width <= 320 ? 3 : 1.5,
          content: FutureBuilder<Travels>(
              future: getListTravels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height));
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Text('');
                }

                var travel = snapshot.data!;

                for (int i = 0; i < travel.travels.length; i++) {
                  if (!locationList.contains(travel.travels[i].location)) {
                    locationList.add(travel.travels[i].location);
                  }
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez choisir votre date de départ';
                              }
                              return null;
                            },
                            controller: dateController,
                            readOnly: true,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Date de départ*',
                                labelStyle: TextStyle(fontSize: 14),
                                icon: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.blue,
                                  size: 30.0,
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 5, 0, 5)),
                            onTap: () {
                              BottomPicker.date(
                                title: "Choisissez votre date de départ",
                                titleStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.blue),
                                onChange: (index) {
                                  dateController.text =
                                      DateFormat('yyyy-MM-dd').format(index);
                                },
                                onSubmit: (index) {
                                  dateController.text =
                                      DateFormat('yyyy-MM-dd').format(index);
                                },
                              ).show(context);
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 30.0,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: DropdownButtonFormField<String>(
                                    menuMaxHeight: 130,
                                    value: selectedLocation,
                                    hint: const Text("Destination*"),
                                    onChanged: (value) => setState(
                                        () => selectedLocation = value),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez choisir votre destination';
                                      }
                                      return null;
                                    },
                                    items: locationList
                                        .map<DropdownMenuItem<String>>(
                                            (dynamic value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text(value.toString()),
                                      );
                                    }).toList())),
                          ])
                        ])),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                          backgroundColor: const Color(0xFF0081CF),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      child: const AutoSizeText(
                        "Valider",
                        maxLines: 1,
                        minFontSize: 11,
                        maxFontSize: 13,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontFamily: "Poppins", color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var date = dateController.text;

                          var travels = await TravelsService()
                              .searchTravels(token!, selectedLocation!);

                          if (travels != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TravelDetailsPage(
                                        travelId: travels.travels[0].id,
                                        date: date,
                                        location: selectedLocation)));
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),
          contentHeight: MediaQuery.of(context).size.width <= 320 ? 4.2 : 6.0,
          containerHeight: MediaQuery.of(context).size.width <= 320 ? 1.7 : 2,
          title: "Recherche",
          redirect: "/home",
        ));
  }
}
