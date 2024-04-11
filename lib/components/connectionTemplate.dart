import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/components/dialogMessage.dart';
import 'package:viami/components/snackBar.dart';
import 'package:viami/services/user/user.service.dart';

class ConnectionTemplate extends StatefulWidget {
  final Widget form;
  final String title;
  final String subtitle;
  final Widget button;
  final String optionText;
  final String optionAction;
  final String redirectText;
  final String? forgetPassword;

  const ConnectionTemplate(
      {Key? key,
      required this.form,
      required this.title,
      required this.subtitle,
      required this.button,
      required this.optionText,
      required this.optionAction,
      required this.redirectText,
      this.forgetPassword})
      : super(key: key);

  @override
  State<ConnectionTemplate> createState() => _ConnectionTemplateState();
}

class _ConnectionTemplateState extends State<ConnectionTemplate> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFFFFFFFF),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
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
                          padding: const EdgeInsets.fromLTRB(20, 65, 0, 30),
                          child: Image.network(
                            "${dotenv.env['CDN_URL']}/assets/logo.png",
                            width: MediaQuery.of(context).size.width / 4.0,
                          )),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: AutoSizeText(
                            widget.title,
                            style: const TextStyle(
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
                          child: AutoSizeText(
                            widget.subtitle,
                            minFontSize: 9,
                            maxFontSize: 13,
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height < 600
                            ? 30.0
                            : 40.0),
                  ])),
              widget.form,
              widget.forgetPassword != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              child: AutoSizeText(widget.forgetPassword!,
                                  minFontSize: 11,
                                  maxFontSize: 13,
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xFF0081CF))),
                              onPressed: () {
                                showDialogMessage(
                                    context,
                                    "Mot de passe oublié ?",
                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Veuillez remplir votre email';
                                                }
                                                return null;
                                              },
                                              controller: emailController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        10, 5, 10, 5),
                                                labelText: 'Email*',
                                                focusedBorder:
                                                    OutlineInputBorder(),
                                                floatingLabelStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 81, 81, 81)),
                                                hintText:
                                                    ' Ex: example@gmail.com',
                                                labelStyle:
                                                    TextStyle(fontSize: 12),
                                                prefixIcon: Icon(
                                                  Icons.email_outlined,
                                                  color: Colors.grey,
                                                  size: 25.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: TextButton(
                                                child: const Text("Annuler",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                }))),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: TextButton(
                                                child: const Text("Valider",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    var email =
                                                        emailController.text;

                                                    var user =
                                                        await UserService()
                                                            .forgetPassword(
                                                                email);

                                                    if (user != null) {
                                                      if (user["message"] ==
                                                          "Email sent") {
                                                        Navigator.pop(context);
                                                        emailController.clear();

                                                        showSnackbar(
                                                            context,
                                                            "Un e-mail vous a été envoyé. Veuillez vérifier votre boîte de réception ou le courrier indésirable (spam) pour le trouver.",
                                                            "D'accord",
                                                            "");
                                                      }
                                                    }
                                                  }
                                                }))));
                              })))
                  : Container(),
              widget.button,
              const SizedBox(height: 20),
              const AutoSizeText("OU",
                  minFontSize: 11,
                  maxFontSize: 13,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(widget.optionText,
                      minFontSize: 11,
                      maxFontSize: 13,
                      style: const TextStyle()),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, widget.optionAction);
                      },
                      child: AutoSizeText(widget.redirectText,
                          minFontSize: 11,
                          maxFontSize: 13,
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xFF0081CF)))),
                ],
              ),
              const SizedBox(height: 20),
            ]))));
  }
}
