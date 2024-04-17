import 'package:age_calculator/age_calculator.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:viami/components/alertMessage.dart';
import 'package:viami/components/connectionTemplate.dart';
import 'package:viami/components/locationPermission.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/components/snackBar.dart';
import 'package:viami/screens/completeRegister.dart';
import 'package:viami/services/user/user.service.dart';

enum Gender { Homme, Femme }

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  FocusNode focusNode = FocusNode();
  String phoneNumber = "";
  bool passwordVisible = false;
  DateTime? birthday;
  //Gender? choosenGender;
  Gender? choosenGender = Gender.Homme;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    void fetchLocation() async {
      String? location = await getMyCurrentPosition(context);

      if (location != null) {
        locationController.text = location;
      }
    }

    return Scaffold(
        body: ConnectionTemplate(
            title: "Monter à bord !",
            subtitle: "Créez votre compte pour commencer votre voyage",
            form: Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Row(children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir votre prénom';
                            }
                            return null;
                          },
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            labelText: 'Prénom*',
                            labelStyle: TextStyle(fontSize: 12),
                            focusedBorder: OutlineInputBorder(),
                            floatingLabelStyle: TextStyle(
                                color: Color.fromARGB(255, 81, 81, 81)),
                            prefixIcon: Icon(
                              Icons.account_circle_outlined,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                          ),
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir votre nom';
                            }
                            return null;
                          },
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nom*',
                            focusedBorder: OutlineInputBorder(),
                            floatingLabelStyle: TextStyle(
                                color: Color.fromARGB(255, 81, 81, 81)),
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                        ))
                      ]),
                      Column(children: <Widget>[
                        const SizedBox(height: 10),
                        Container(
                            padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 99, 99, 99)),
                            ),
                            child: Row(children: [
                              const Text("Genre : ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 81, 81, 81))),
                              const SizedBox(height: 20),
                              Row(children: [
                                Radio<Gender>(
                                  activeColor:
                                      const Color.fromARGB(255, 99, 99, 99),
                                  focusColor:
                                      const Color.fromARGB(255, 99, 99, 99),
                                  hoverColor:
                                      const Color.fromARGB(255, 99, 99, 99),
                                  fillColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 99, 99, 99)),
                                  value: Gender.Homme,
                                  groupValue: choosenGender,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      choosenGender = value;
                                    });
                                  },
                                ),
                                const Text("Homme",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 99, 99, 99)))
                              ]),
                              Row(children: [
                                Radio<Gender>(
                                  activeColor:
                                      const Color.fromARGB(255, 99, 99, 99),
                                  focusColor:
                                      const Color.fromARGB(255, 99, 99, 99),
                                  hoverColor:
                                      const Color.fromARGB(255, 99, 99, 99),
                                  fillColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 99, 99, 99)),
                                  value: Gender.Femme,
                                  groupValue: choosenGender,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      choosenGender = value;
                                    });
                                  },
                                ),
                                const Text("Femme",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 99, 99, 99)))
                              ])
                            ])),
                      ]),
                      const SizedBox(height: 10),
                      Column(children: [
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
                              border: OutlineInputBorder(),
                              labelText: 'Date de naissance*',
                              labelStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              focusedBorder: OutlineInputBorder(),
                              floatingLabelStyle: TextStyle(
                                  color: Color.fromARGB(255, 81, 81, 81)),
                              prefixIcon: Icon(
                                Icons.cake_outlined,
                                color: Colors.grey,
                                size: 25.0,
                              )),
                          onTap: () {
                            BottomPicker.date(
                              titlePadding: const EdgeInsets.only(top: 20),
                              title: "Définissez votre date de naissance",
                              titleStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xFF0081CF)),
                              buttonStyle: const BoxDecoration(
                                  color: Color(0xFF0081CF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  )),
                              buttonContent: const Text(
                                "Valider",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
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
                          height: 10,
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
                              border: OutlineInputBorder(),
                              labelText: 'Localisation*',
                              labelStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              focusedBorder: OutlineInputBorder(),
                              floatingLabelStyle: TextStyle(
                                  color: Color.fromARGB(255, 81, 81, 81)),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 25.0,
                              )),
                          onTap: () {
                            fetchLocation();
                          },
                        ),
                      ]),
                      const SizedBox(height: 10),
                      IntlPhoneField(
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Numéro de téléphone',
                          hintText: "690752111",
                          focusedBorder: OutlineInputBorder(),
                          floatingLabelStyle:
                              TextStyle(color: Color.fromARGB(255, 81, 81, 81)),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          labelStyle: TextStyle(fontSize: 12),
                        ),
                        languageCode: "fr",
                        invalidNumberMessage:
                            "Veuillez remplir votre numéro de téléphone",
                        onChanged: (phone) {
                          phoneNumber = phone.countryCode + phone.number;
                        },
                        onCountryChanged: (country) {},
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                          RegExp regex = RegExp(pattern);

                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir votre email';
                          } else if (!regex.hasMatch(value)) {
                            String message =
                                "Veuillez remplir un email valide. \nExample : example@gmail.com";
                            return message;
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          labelText: 'Email*',
                          hintText: ' Ex: example@gmail.com',
                          labelStyle: TextStyle(fontSize: 12),
                          focusedBorder: OutlineInputBorder(),
                          floatingLabelStyle:
                              TextStyle(color: Color.fromARGB(255, 81, 81, 81)),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                            size: 25.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          String pattern =
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z\d]).{8,}$';
                          RegExp regex = RegExp(pattern);

                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir votre mot de passe';
                          } else if (!regex.hasMatch(value)) {
                            String message =
                                "Votre mot de passe doit comporter : \n" +
                                    "\u2022 Au moins 8 caractères \n" +
                                    "\u2022 Une lettre minuscule \n" +
                                    "\u2022 Une lettre majuscule \n" +
                                    "\u2022 Un chiffre \n" +
                                    "\u2022 Un caractère spécial () [] ! _ @ & \$ # + - / *";
                            return message;
                          }

                          return null;
                        },
                        controller: passwordController,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Mot de passe*',
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            labelStyle: const TextStyle(fontSize: 12),
                            focusedBorder: const OutlineInputBorder(),
                            floatingLabelStyle: const TextStyle(
                                color: Color.fromARGB(255, 81, 81, 81)),
                            prefixIcon: const Icon(
                              Icons.fingerprint,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            )),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ],
                  )),
            ),
            button: Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
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
                          "S'inscrire",
                          maxLines: 1,
                          minFontSize: 11,
                          maxFontSize: 13,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontFamily: "Poppins", color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var firstName = firstNameController.text;
                            var lastName = lastNameController.text;
                            var phone = phoneNumber;
                            var email = emailController.text;
                            var password = passwordController.text;

                            var birthday = birthdayController.text;
                            var birthdayInt = DateTime(
                                int.parse(birthday.split('-')[0]),
                                int.parse(birthday.split('-')[1]),
                                int.parse(birthday.split('-')[2]));
                            var ageCalculate = AgeCalculator.age(birthdayInt)
                                .toString()
                                .split(",")[0];
                            var age = int.parse(ageCalculate.split(" ")[1]);
                            var location = locationController.text;

                            var sex = "";

                            if (choosenGender == Gender.Homme) {
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
                              var storage = const FlutterSecureStorage();

                              var fcmToken =
                                  await storage.read(key: "fcmToken");

                              var user = await UserService().register(
                                  firstName,
                                  lastName,
                                  email,
                                  password,
                                  phone,
                                  location,
                                  birthday,
                                  sex,
                                  fcmToken.toString());

                              if (user != null) {
                                if (user.message == "User already exists") {
                                  showSnackbar(
                                      context,
                                      'Vous avez déjà un compte !',
                                      'Se connecter',
                                      '/login');
                                } else {
                                  Navigator.pushNamed(context, '/login');

                                  showSnackbar(
                                      context,
                                      "Veuillez finaliser votre inscription en vérifiant votre adresse e-mail envoyé sur votre mail ! Vérifiez vos spams si vous ne trouvez pas le mail",
                                      "D'accord",
                                      '');
                                }
                              }
                            }
                          }
                        }))),
            optionText: "Vous avez déjà un compte ?",
            optionAction: "/login",
            redirectText: "Se connecter"));
  }
}
