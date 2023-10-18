import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:viami/components/connectionTemplate.dart';
import 'package:viami/components/snackBar.dart';
import 'package:viami/screens/completeRegister.dart';
import 'package:viami/services/auth.service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode focusNode = FocusNode();
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
            title: "Re-Bienvenue",
            subtitle:
                "Continuez à planifier votre voyage avec de nouvelles personnes",
            form: Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
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
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir votre mot de passe';
                          }
                          return null;
                        },
                        obscureText: passwordVisible,
                        controller: passwordController,
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
                        "Se connecter",
                        maxLines: 1,
                        minFontSize: 11,
                        maxFontSize: 13,
                        overflow: TextOverflow.fade,
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var email = emailController.text;
                          var password = passwordController.text;

                          var user = await AuthService().login(email, password);

                          var storage = const FlutterSecureStorage();

                          if (user != null) {
                            if (user["message"] == "User not found") {
                              showSnackbar(
                                  context,
                                  "Cet email n'a pas encore un compte, inscrivez-vous !",
                                  "S'inscrire",
                                  "/register");
                            } else {
                              storage.write(
                                  key: "userId", value: user["user"]["id"]);
                              storage.write(key: "token", value: user['token']);

                              Navigator.pushNamed(context, "/login");
                            }
                          }
                        }
                      },
                    ))),
            optionText: "Vous n'avez pas un compte ?",
            optionAction: "/register",
            redirectText: "S'inscrire"));
  }
}
