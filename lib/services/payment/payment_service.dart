import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stripe_checkout/stripe_checkout.dart';

class PaymentService {
  Future<dynamic> createCheckoutSession(dynamic product, int amount) async {
    final url = Uri.parse("${dotenv.env['STRIPE_URL']}/checkout/sessions");

    String item = "";

    item += "&line_items[0][price_data][product_data][name]=${product["name"]}";
    item += "&line_items[0][price_data][unit_amount]=${product["price"]}";
    item += "&line_items[0][price_data][currency]=EUR";
    item += "&line_items[0][quantity]=1";

    final response = await http.post(url,
        body: "success_url=${dotenv.env['SUCCESS_URL']}&mode=payment$item",
        headers: {
          "Authorization": "Bearer ${dotenv.env['STRIPE_SECRET_KEY']}",
          "Content-Type": "application/x-www-form-urlencoded"
        });

    return json.decode(response.body)["id"];
  }

  Future<dynamic> stripePaymentCheckout(product, total, context, mounted,
      {onSuccess, onCancel, onError}) async {
    final String sessionId = await createCheckoutSession(product, total);

    final result = await redirectToCheckout(
        context: context,
        sessionId: sessionId,
        publishableKey: "${dotenv.env['STRIPE_PUBLIC_KEY']}",
        successUrl: "${dotenv.env['SUCCESS_URL']}",
        canceledUrl: "${dotenv.env['CANCEL_URL']}");

    if (mounted) {
      final text = result.when(
          redirected: () => "Redirigé avec succès",
          success: () => onSuccess(),
          canceled: () => onCancel(),
          error: (e) => onError(e));

      return text;
    }
  }
}
