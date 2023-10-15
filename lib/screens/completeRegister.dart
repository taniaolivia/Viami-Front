import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:viami/models-api/user.dart';

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
  DateTime? birthday;
  Gender? choosenGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: const Color(0xFFE5F3FF),
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 40, 0, 0),
                                child: Image.asset(
                                  "assets/logo.png",
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                )),
                          ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: AutoSizeText(
                                  "Monter à bord !",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  minFontSize: 30,
                                  maxFontSize: 35,
                                  textAlign: TextAlign.left,
                                )),
                          ),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                                child: AutoSizeText(
                                  "Créez votre compte pour commencer votre voyage",
                                  minFontSize: 17,
                                  maxFontSize: 20,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white),
                                )),
                          ),
                          const SizedBox(height: 40),
                        ])),
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const AutoSizeText(
                            "Vous êtes",
                            minFontSize: 22,
                            maxFontSize: 25,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          GenderPickerWithImage(
                            maleText: "Homme",
                            femaleText: "Femme",
                            selectedGender: Gender.Male,
                            selectedGenderTextStyle: const TextStyle(
                                color: Color(0xFF0081CF),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins"),
                            unSelectedGenderTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Poppins"),
                            onChanged: (Gender? gender) {
                              choosenGender = gender;
                            },
                            equallyAligned: true,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            isCircular: true,
                            opacityOfGradient: 0.4,
                            padding: const EdgeInsets.all(3),
                            size: 50,
                          ),
                          const SizedBox(height: 50),
                          Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(50, 10, 50, 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez remplir votre date de naissance';
                                  }
                                  return null;
                                },
                                controller: birthdayController,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Date de naissance*',
                                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                                  icon: Icon(
                                    Icons.cake_outlined,
                                    color: Colors.blue,
                                    size: 40.0,
                                  ),
                                ),
                                onTap: () {
                                  BottomPicker.date(
                                    title: "Définissez votre date de naissance",
                                    titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.blue),
                                    onChange: (index) {
                                      birthdayController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(index);
                                    },
                                    onSubmit: (index) {
                                      birthdayController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(index);
                                    },
                                  ).show(context);
                                },
                              )),
                          const SizedBox(
                            height: 70,
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 15, 40, 15),
                                        backgroundColor:
                                            const Color(0xFF0081CF),
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    child: const AutoSizeText(
                                      "Valider",
                                      maxLines: 1,
                                      minFontSize: 20,
                                      maxFontSize: 22,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        var birthday = birthdayController.text;
                                        var birthdayInt = DateTime(
                                            int.parse(birthday.split('-')[0]),
                                            int.parse(birthday.split('-')[1]),
                                            int.parse(birthday.split('-')[2]));
                                        var age = AgeCalculator.age(birthdayInt)
                                            .toString()
                                            .split(",")[0];

                                        var sex = "";

                                        if (choosenGender == Gender.Male) {
                                          sex = "m";
                                        } else {
                                          sex = "f";
                                        }

                                        var user = await register(
                                            widget.firstName,
                                            widget.lastName,
                                            widget.email,
                                            widget.password,
                                            widget.phone,
                                            "Paris",
                                            int.parse(age.split(" ")[1]),
                                            sex);

                                        var storage = FlutterSecureStorage();

                                        if (user != null) {
                                          storage.write(
                                              key: "id", value: user.id);
                                          storage.write(
                                              key: "email", value: user.email);
                                          storage.write(
                                              key: "firstName",
                                              value: user.firstName);
                                          storage.write(
                                              key: "lastName",
                                              value: user.lastName);

                                          Navigator.pushNamed(
                                              context, '/login');
                                        }
                                      }
                                    },
                                  )))
                        ]))
                  ],
                ))));
  }
}
