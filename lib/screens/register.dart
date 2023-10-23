import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:viami/components/connectionTemplate.dart';
import 'package:viami/screens/completeRegister.dart';

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
  FocusNode focusNode = FocusNode();
  String phoneNumber = "";
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
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
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                        ))
                      ]),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir votre email';
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
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                            size: 25.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      IntlPhoneField(
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Numéro de téléphone',
                          hintText: "690752111",
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
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var firstName = firstNameController.text;
                          var lastName = firstNameController.text;
                          var phone = phoneNumber;
                          var email = emailController.text;
                          var password = passwordController.text;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompleteRegisterPage(
                                    firstName: firstName,
                                    lastName: lastName,
                                    phone: phone,
                                    email: email,
                                    password: password)),
                          );
                        }
                      },
                    ))),
            optionText: "Vous avez déjà un compte ?",
            optionAction: "/login",
            redirectText: "Se connecter"));
  }
}
