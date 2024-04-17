import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:viami/components/singletons_data.dart';
import 'package:viami/constant.dart';
import 'package:viami/models/styles.dart';

class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({Key? key, required this.offering}) : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  Package? product;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            Container(
              height: 70.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: kColorBar,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              child: const Center(
                  child: Text('✨ Viami Premium', style: kTitleTextStyle)),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                child: Text(
                  'VIAMI PREMIUM',
                  style: TextStyle(color: Colors.black),
                ),
                width: double.infinity,
              ),
            ),
            ListView.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (BuildContext context, int index) {
                var myProductList = widget.offering.availablePackages;

                product = myProductList[0];
                return Card(
                  color: const Color.fromARGB(255, 175, 225, 254),
                  child: ListTile(
                      onTap: () async {},
                      title: Text(
                        myProductList[index].storeProduct.title,
                        style: kTitleTextStyle,
                      ),
                      subtitle: Text(
                        myProductList[index].storeProduct.description,
                        style: kDescriptionTextStyle.copyWith(
                            fontSize: kFontSizeSuperSmall),
                      ),
                      trailing: Text(
                          myProductList[index].storeProduct.priceString,
                          style: kTitleTextStyle)),
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 10, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                width: double.infinity,
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0081CF),
                      padding: const EdgeInsets.only(
                          top: 14, bottom: 14, right: 30, left: 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        CustomerInfo customerInfo =
                            await Purchases.purchasePackage(product!);
                        EntitlementInfo? entitlement =
                            customerInfo.entitlements.all[entitlementID];
                        appData.entitlementIsActive =
                            entitlement?.isActive ?? false;
                      } catch (e) {
                        print(e);
                      }

                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text("Payer",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800))))
          ],
        ),
      ),
    );
  }
}
