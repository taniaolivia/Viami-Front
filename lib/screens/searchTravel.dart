import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
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

  Future<void> showDatePickerDialog(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      locale: const Locale('fr', 'FR'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: "Sélectionner votre date de départ",
    );

    if (selectedDate != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    } else {
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Travels>(
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
            return const Text(
              '',
              textAlign: TextAlign.center,
            );
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
                            labelStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 81, 81, 81)),
                            hintText: 'Date de départ*',
                            hintStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 81, 81, 81)),
                            focusedBorder: UnderlineInputBorder(),
                            floatingLabelStyle: TextStyle(
                                color: Color.fromARGB(255, 81, 81, 81)),
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.blue,
                              size: 30.0,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
                        onTap: () => showDatePickerDialog(context)),
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
                              dropdownColor: Colors.white,
                              decoration: const InputDecoration(
                                labelText: "Destination*",
                                hintText: "Destination*",
                                hintStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 81, 81, 81)),
                                labelStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 81, 81, 81)),
                              ),
                              menuMaxHeight: 300,
                              value: selectedLocation,
                              onChanged: (value) => setState(() => {
                                    if (selectedLocation != null)
                                      {selectedLocation = value}
                                    else
                                      {selectedLocation = ""}
                                  }),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value == "") {
                                  return 'Veuillez choisir votre destination';
                                }
                                return null;
                              },
                              items: locationList.map<DropdownMenuItem<String>>(
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
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                child: const AutoSizeText(
                  "Valider",
                  maxLines: 1,
                  minFontSize: 11,
                  maxFontSize: 13,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontFamily: "Poppins", color: Colors.white),
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
        });
  }
}
