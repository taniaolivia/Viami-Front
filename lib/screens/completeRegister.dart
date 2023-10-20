import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:viami/components/locationPermission.dart';
import 'package:viami/components/snackBar.dart';
import 'package:viami/components/alertMessage.dart';
import 'package:viami/services/user.service.dart';

class CompleteRegisterPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;

  const CompleteRegisterPage(
      {Key? key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.password})
      : super(key: key);

  @override
  State<CompleteRegisterPage> createState() => _CompleteRegisterPageState();
}

class _CompleteRegisterPageState extends State<CompleteRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  DateTime? birthday;
  Gender? choosenGender;

  @override
  Widget build(BuildContext context) {
    void fetchLocation() async {
      String? location = await getMyCurrentPosition(context);

      if (location != null) {
        locationController.text = location;
      }
    }

    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF0081CF),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                    child: Column(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 60, 0, 0),
                            child: Image.asset(
                              "assets/logo.png",
                              width: MediaQuery.of(context).size.width / 2.2,
                            )),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height < 600
                              ? 10.0
                              : 20.0),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: AutoSizeText(
                              "Monter à bord !",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              minFontSize: 18,
                              maxFontSize: 20,
                              textAlign: TextAlign.left,
                            )),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                20,
                                MediaQuery.of(context).size.height < 600
                                    ? 10.0
                                    : 20.0,
                                0,
                                0),
                            child: const AutoSizeText(
                              "Créez votre compte pour commencer votre voyage",
                              minFontSize: 9,
                              maxFontSize: 13,
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height < 600
                              ? 30.0
                              : 40.0),
                    ])),
                Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                                color: Color(0xFFFFDAA2),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: const AutoSizeText(
                              "Completez mon profil",
                              minFontSize: 17,
                              maxFontSize: 20,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const AutoSizeText(
                            "Je suis",
                            minFontSize: 15,
                            maxFontSize: 22,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          GenderPickerWithImage(
                            maleText: "Homme",
                            femaleText: "Femme",
                            selectedGender: Gender.Male,
                            selectedGenderTextStyle: const TextStyle(
                              color: Color(0xFF0081CF),
                              fontWeight: FontWeight.bold,
                            ),
                            unSelectedGenderTextStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                            onChanged: (Gender? gender) {
                              choosenGender = gender;
                            },
                            equallyAligned: true,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            isCircular: true,
                            opacityOfGradient: 0.4,
                            padding: const EdgeInsets.all(3),
                            size: 30,
                          )
                        ],
                      )),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                        child: Column(children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez remplir votre date de naissance';
                              }
                              return null;
                            },
                            controller: birthdayController,
                            readOnly: true,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Date de naissance*',
                                labelStyle: TextStyle(fontSize: 12),
                                icon: Icon(
                                  Icons.cake_outlined,
                                  color: Colors.blue,
                                  size: 25.0,
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 5, 0, 5)),
                            onTap: () {
                              BottomPicker.date(
                                title: "Définissez votre date de naissance",
                                titleStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.blue),
                                onChange: (index) {
                                  birthdayController.text =
                                      DateFormat('yyyy-MM-dd').format(index);
                                },
                                onSubmit: (index) {
                                  birthdayController.text =
                                      DateFormat('yyyy-MM-dd').format(index);
                                },
                              ).show(context);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez vous localiser';
                              }
                              return null;
                            },
                            controller: locationController,
                            readOnly: true,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Localisation*',
                                labelStyle: TextStyle(fontSize: 12),
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 25.0,
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 5, 0, 5)),
                            onTap: () {
                              fetchLocation();
                            },
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 15, 40, 15),
                                    backgroundColor: const Color(0xFF0081CF),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                child: const AutoSizeText(
                                  "Valider",
                                  maxLines: 1,
                                  minFontSize: 11,
                                  maxFontSize: 13,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(fontFamily: "Poppins"),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    var birthday = birthdayController.text;
                                    var birthdayInt = DateTime(
                                        int.parse(birthday.split('-')[0]),
                                        int.parse(birthday.split('-')[1]),
                                        int.parse(birthday.split('-')[2]));
                                    var ageCalculate =
                                        AgeCalculator.age(birthdayInt)
                                            .toString()
                                            .split(",")[0];
                                    var age =
                                        int.parse(ageCalculate.split(" ")[1]);
                                    var location = locationController.text;

                                    var sex = "";

                                    if (choosenGender == Gender.Male) {
                                      sex = "m";
                                    } else {
                                      sex = "f";
                                    }

                                    if (age < 18) {
                                      showAlertDialog(
                                          context,
                                          "Restriction d'âge",
                                          "Désolé, vous devez être 18 ans ou plus pour s'inscrire",
                                          "J'ai compris");
                                    } else {
                                      var user = await UserService().register(
                                          widget.firstName,
                                          widget.lastName,
                                          widget.email,
                                          widget.password,
                                          widget.phone,
                                          location,
                                          age,
                                          sex);

                                      if (user != null) {
                                        if (user.message ==
                                            "User already exists") {
                                          showSnackbar(
                                              context,
                                              'Vous avez déjà un compte !',
                                              'Se connecter',
                                              '/login');
                                        } else {
                                          Navigator.pushNamed(
                                              context, '/login');

                                          showSnackbar(
                                              context,
                                              'Votre compte a été bien créé !',
                                              "D'accord",
                                              '');
                                        }
                                      }
                                    }
                                  }
                                },
                              )))
                    ]))
              ],
            ))));
  }
}
