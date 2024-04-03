import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/connectionTemplate.dart';
import 'package:viami/components/snackBar.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';

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
            title: "Bienvenue",
            subtitle: "Connectez-vous pour commencer votre voyage",
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
                          floatingLabelStyle:
                              TextStyle(color: Color.fromARGB(255, 81, 81, 81)),
                          focusedBorder: OutlineInputBorder(),
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
            forgetPassword: "Mot de passe oublié ?",
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
                        style: TextStyle(
                            fontFamily: "Poppins", color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var email = emailController.text;
                          var password = passwordController.text;

                          var user = await AuthService().login(email, password);

                          var storage = const FlutterSecureStorage();

                          print(user);
                          if (user != null) {
                            if (user["message"] == "User not found") {
                              showSnackbar(
                                  context,
                                  "Cet email n'a pas encore un compte, inscrivez-vous !",
                                  "S'inscrire",
                                  "/register");
                            } else if (user["message"] ==
                                "Incorrect password") {
                              showSnackbar(
                                  context,
                                  "Mot de passe est incorrect. Veuillez remplir le bon mot de passe !",
                                  "D'accord",
                                  "");
                            } else if (user["message"] ==
                                "Please verify your email !") {
                              showSnackbar(
                                  context,
                                  "Votre adresse e-mail n'est pas encore vérifié. Un mail a été envoyé sur votre mail ! Vérifiez vos spams si vous ne trouvez pas le mail!",
                                  "D'accord",
                                  "");
                            } else {
                              await storage.write(
                                  key: "userId", value: user["user"]["id"]);
                              await storage.write(
                                  key: "token", value: user['token']);

                              var fcmToken =
                                  await storage.read(key: "fcmToken");

                              await UserService().setFcmToken(
                                  user["user"]["id"], fcmToken!, user['token']);

                              var image = await UsersImagesService()
                                  .getUserImagesById(
                                      user["user"]["id"], user['token']);

                              await storage.write(
                                  key: "userImage",
                                  value: image.userImages.length.toString());

                              Navigator.pushNamed(context, "/home");
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
