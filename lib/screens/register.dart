import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:viami/components/connectionTemplate.dart';

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
            padding: const EdgeInsets.all(20),
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
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                        backgroundColor: const Color(0xFF0081CF),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    child: const AutoSizeText("S'inscrire",
                        maxLines: 1,
                        minFontSize: 20,
                        maxFontSize: 22,
                        overflow: TextOverflow.fade),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var firstName = firstNameController.text;
                        var lastName = firstNameController.text;
                        var phone = firstNameController.text;
                        var email = emailController.text;
                        var password = passwordController.text;

                        Navigator.pushNamed(context, "/register/complete",
                            arguments: {
                              firstName,
                              lastName,
                              phone,
                              email,
                              password
                            });
                      }
                    },
                  ))),
          option: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const AutoSizeText(
                "Vous avez déjà un compte ?",
                minFontSize: 20,
                maxFontSize: 25,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  child: const AutoSizeText("Se connecter",
                      minFontSize: 20,
                      maxFontSize: 25,
                      style: TextStyle(decoration: TextDecoration.underline))),
            ],
          )),
    );
  }
}
