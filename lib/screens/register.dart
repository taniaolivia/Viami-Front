import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
                          labelText: 'Prénom*',
                          labelStyle: TextStyle(fontFamily: 'Poppins'),
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            color: Colors.grey,
                            size: 30.0,
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
                          labelStyle: TextStyle(fontFamily: 'Poppins'),
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
                        labelText: 'Email*',
                        hintText: ' Ex: example@gmail.com',
                        labelStyle: TextStyle(fontFamily: 'Poppins'),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                          size: 30.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir votre numéro de téléphone';
                        }
                        return null;
                      },
                      controller: phoneController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Numéro de téléphone*',
                        labelStyle: TextStyle(fontFamily: 'Poppins'),
                        prefixIcon: Icon(
                          Icons.phone_android_outlined,
                          color: Colors.grey,
                          size: 30.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir votre mot de passe';
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mot de passe*',
                        labelStyle: TextStyle(fontFamily: 'Poppins'),
                        prefixIcon: Icon(
                          Icons.fingerprint,
                          color: Colors.grey,
                          size: 30.0,
                        ),
                      ),
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
                          fontFamily: 'Poppins',
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    child: const AutoSizeText(
                      "S'inscrire",
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
                        var firstName = firstNameController.text;
                        var lastName = firstNameController.text;
                        var phone = firstNameController.text;
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
          option: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const AutoSizeText("Vous avez déjà un compte ?",
                  minFontSize: 16,
                  maxFontSize: 20,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  child: const AutoSizeText("Se connecter",
                      minFontSize: 16,
                      maxFontSize: 20,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline))),
            ],
          )),
    );
  }
}
