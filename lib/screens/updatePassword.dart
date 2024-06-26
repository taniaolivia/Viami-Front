import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/services/user/user.service.dart';

class UpdatePassword extends StatefulWidget {
  final bool? tokenExpired;

  const UpdatePassword({super.key, this.tokenExpired});

  @override
  State<StatefulWidget> createState() => _UpdatePassword();
}

class _UpdatePassword extends State<UpdatePassword> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  String? token = "";
  String? userId = "";
  String? userProfile;
  bool? tokenExpired;
  bool passwordVisible = false;
  bool newPasswordVisible = false;
  bool confirmNewpasswordVisible = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  FocusNode focusNode = FocusNode();

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  bool validatePasswordChange(String newPassword, String confirmPassword) {
    if (newPassword != confirmPassword) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AutoSizeText(
            'Changer le mot de passe',
            minFontSize: 16,
            maxFontSize: 18,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings");
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              )),
          backgroundColor: const Color(0xFF0081CF),
        ),
        body: FutureBuilder<User>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("");
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
              var user = snapshot.data!;
              return Column(children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            obscureText: passwordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez remplir votre ancien mot de passe';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 15, 10, 5),
                              prefixIcon: const Icon(
                                Icons.fingerprint,
                                color: Colors.grey,
                                size: 25.0,
                              ),
                              border: const OutlineInputBorder(),
                              labelStyle: const TextStyle(fontSize: 12),
                              labelText: 'Ancien mot de passe',
                              focusedBorder: const OutlineInputBorder(),
                              floatingLabelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 81, 81, 81)),
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
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
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
                            controller: newPasswordController,
                            obscureText: newPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Nouveau mot de passe',
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              prefixIcon: const Icon(
                                Icons.fingerprint,
                                color: Colors.grey,
                                size: 25.0,
                              ),
                              border: const OutlineInputBorder(),
                              labelStyle: const TextStyle(fontSize: 12),
                              focusedBorder: const OutlineInputBorder(),
                              floatingLabelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 81, 81, 81)),
                              suffixIcon: IconButton(
                                icon: Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(
                                    () {
                                      newPasswordVisible = !newPasswordVisible;
                                    },
                                  );
                                },
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
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
                            controller: confirmNewPasswordController,
                            obscureText: confirmNewpasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Confirmer le nouveau mot de passe',
                              contentPadding: const EdgeInsets.all(15.0),
                              prefixIcon: const Icon(
                                Icons.fingerprint,
                                color: Colors.grey,
                                size: 25.0,
                              ),
                              border: const OutlineInputBorder(),
                              labelStyle: const TextStyle(fontSize: 12),
                              focusedBorder: const OutlineInputBorder(),
                              floatingLabelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 81, 81, 81)),
                              suffixIcon: IconButton(
                                icon: Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(
                                    () {
                                      confirmNewpasswordVisible =
                                          !confirmNewpasswordVisible;
                                    },
                                  );
                                },
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var newPassword = newPasswordController.text;
                              var confirmPassword =
                                  confirmNewPasswordController.text;
                              if (!validatePasswordChange(
                                  newPassword, confirmPassword)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Les mots de passe ne correspondent pas.",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                );
                                return;
                              }

                              bool passwordChangeSuccess = await UserService()
                                  .updateUserPasswordById(
                                      userId, token!, newPassword);

                              if (passwordChangeSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Votre mot de passe a bien été mis à jour!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    duration: Duration(seconds: 7),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Echec de la mise à jour du mot de passe !",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    duration: Duration(seconds: 7),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0081CF),
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width - 40, 0),
                          ),
                          child: const Text(
                            'Valider',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]);
            }));
  }
}
