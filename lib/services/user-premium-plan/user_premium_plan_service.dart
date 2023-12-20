import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/premium-plan/premium_plans.dart';

/*class PremiumPlansService {
  Future<PremiumPlans> getAllPremiumPlans(String token) async {
    final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/premiumPlans'),
        headers: <String, String>{
          'Authorization': token,
        });

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return PremiumPlans.fromJson(res);
    } else {
      throw Exception('Failed to load premium plans');
    }
  }
}*/
