import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viami/components/native_dialog.dart';
import 'package:viami/components/singletons_data.dart';
import 'package:viami/constant.dart';
import 'package:viami/models-api/premium-plan/premium_plans.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models/styles.dart';
import 'package:viami/screens/paywall.dart';
import 'package:viami/services/payment/payment_service.dart';
import 'package:viami/services/premium-plan/premium_plans_service.dart';
import 'package:viami/services/user-premium-plan/user_premium_plan_service.dart';
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
  String priceText = "3.99";
  int priceInt = 399;
  String planName = "1 semaine";
  List description = [];
  bool _isLoading = false;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  Future<PremiumPlans> getPremiumPlans() async {
    token = await storage.read(key: "token");

    return PremiumPlansService().getAllPremiumPlans(token.toString());
  }

  void pay() async {
    setState(() {
      _isLoading = true;
    });

    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: "Vous êtes déjà abonné",
              content:
                  "Votre abonnement à Premium 1 semaine sera renouvelé automatiquement. Pour consulter les options de l'abonnement ou le résilier, veuillez consulter les paramètres dans votre portable.",
              buttonText: 'OK'));

      setState(() {
        _isLoading = false;
      });
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        await showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: "Erreur",
                content: e.message ?? "Erreur pendant le paiement",
                buttonText: 'OK'));
      }

      setState(() {
        _isLoading = false;
      });

      if (offerings == null || offerings.current == null) {
      } else {
        try {
          CustomerInfo customerInfo = await Purchases.purchasePackage(
              offerings!.current!.availablePackages[0]);
          EntitlementInfo? entitlement =
              customerInfo.entitlements.all[entitlementID];
          appData.entitlementIsActive = entitlement?.isActive ?? false;

          await UserPremiumPlansService()
              .addUserPremiumPlan(token.toString(), userId.toString(), 1);
          Navigator.pushNamed(context, "/home");
        } catch (e) {
          print(e);
        }

        setState(() {});
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getPremiumPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PremiumPlans>(
          future: getPremiumPlans(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              );
            }

            if (snapshot.hasError) {
              return const Text(
                '',
                textAlign: TextAlign.center,
              );
            }

            if (!snapshot.hasData) {
              return const Text("");
            }

            description = [];

            var plans = snapshot.data!;

            description = plans.plans[0].description.split(", ");
            planName = plans.plans[0].plan;
            priceText = plans.plans[0].price;
            priceInt = (double.parse(plans.plans[0].price) * 100).round();

            return SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 55, 20, 20),
                    child: Column(children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: IconButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, "/home"),
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Color(0xFF0081CF),
                                    size: 20,
                                  ),
                                )),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: Image.network(
                              "${dotenv.env['CDN_URL']}/assets/logo-blue.png")),
                      const SizedBox(
                        height: 40,
                      ),
                      Column(children: [
                        const AutoSizeText(
                            "Discutez en illimité et découvrez le monde à plusieurs.",
                            minFontSize: 16,
                            maxFontSize: 18,
                            style: TextStyle(
                                color: Color(0xFF0A2753),
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(children: [
                          Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 1.4,
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: const Color(0xFFDADADA),
                                ),
                                color: const Color(0xFFEDEEEF),
                              ),
                              child: Column(children: [
                                Container(
                                  width: 260,
                                  height: 140,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 10.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(
                                            0.0,
                                            0.0,
                                          ),
                                        )
                                      ],
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            "${dotenv.env['CDN_URL']}/assets/premium/one_week.png",
                                          ))),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                          toBeginningOfSentenceCase(
                                              plans.plans[0].plan)!,
                                          minFontSize: 16,
                                          maxFontSize: 18,
                                          style: const TextStyle(
                                              color: Color(0xFF0A2753),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(plans.plans[0].by,
                                          minFontSize: 11,
                                          maxFontSize: 13,
                                          style: const TextStyle(
                                              color: Color(0xFF0A2753)))),
                                ]),
                              ])),
                          const SizedBox(
                            height: 35,
                          ),
                          Column(
                              children: List.generate(description.length,
                                  (indexDesc) {
                            return Align(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                    "${indexDesc + 1}. ${description[indexDesc]}",
                                    minFontSize: 14,
                                    maxFontSize: 16,
                                    style: const TextStyle(
                                        color: Color(0xFF0A2753))));
                          })),
                          const SizedBox(
                            height: 25,
                          ),
                        ]),
                        Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Column(children: [
                              const Divider(
                                height: 20,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                                color: Colors.grey,
                              ),
                              AutoSizeText.rich(
                                TextSpan(
                                  text:
                                      "En appuyant sur continuer, votre achat sera facturé, votre abonnement sera automatiquement renouvelé pour le même prix et la même durée jusqu'à ce que vous l'annulez dans les paramètres de l'App store ou le Play store. Vous acceptez également nos ",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xFF0A2753),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Conditions d'utilisation",
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await launchUrl(Uri.parse(
                                              'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'));
                                        },
                                    ),
                                    const TextSpan(
                                      text: " et notre ",
                                    ),
                                    TextSpan(
                                      text: "Politique de confidentialité.",
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await launchUrl(Uri.parse(
                                              'https://viami-api.onrender.com/politique-de-confidentialite'));
                                        },
                                    ),
                                  ],
                                ),
                                minFontSize: 8,
                                maxFontSize: 10,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                  width: 250,
                                  height: 50,
                                  child: FloatingActionButton(
                                    backgroundColor: const Color(0xFF0081CF),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: AutoSizeText(
                                      "Continuer - $priceText€ total",
                                      maxLines: 1,
                                      minFontSize: 17,
                                      maxFontSize: 20,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                          fontFamily: "Poppins",
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () {
                                      pay();
                                    },
                                  ))
                            ]))
                      ])
                    ])));
          }),
    );
  }
}
