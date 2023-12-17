import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/services/payment/payment_service.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final storage = const FlutterSecureStorage();
  String? token;
  String? userId;

  bool? tokenExpired;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");
      bool isTokenExpired = AuthService().isTokenExpired(token!);

      tokenExpired = isTokenExpired;

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  Future<void> fetchData() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AutoSizeText(
            'Paiement',
            minFontSize: 16,
            maxFontSize: 18,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              )),
          backgroundColor: const Color(0xFF0081CF),
        ),
        body: Center(
            child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                backgroundColor: const Color(0xFF0081CF),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            child: const AutoSizeText(
              "Valider",
              maxLines: 1,
              minFontSize: 13,
              maxFontSize: 15,
              overflow: TextOverflow.fade,
              style: TextStyle(fontFamily: "Poppins", color: Colors.white),
            ),
            onPressed: () async {
              await PaymentService().stripePaymentCheckout(
                  {"name": "Premium", "price": 50}, 50, context, mounted,
                  onSuccess: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('Information'),
                          content: const Text(
                              "Votre paiement a été traité avec succès. Vous pouvez commencer de profiter l'abonnement premium"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, "/home");
                              },
                              child: const Text("D'accord"),
                            ),
                          ]);
                    });
              }, onCancel: () {
                print("Cancel");
              }, onError: (e) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('Information'),
                          content: const Text(
                              "Votre paiement n'a pas été traité avec succès. Veuillez nous contacter si ce problème pérsiste !"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, "/home");
                              },
                              child: const Text("D'accord"),
                            ),
                          ]);
                    });
                print("Error: " + e.toString());
              });
            },
          )
        ])));
  }
}
