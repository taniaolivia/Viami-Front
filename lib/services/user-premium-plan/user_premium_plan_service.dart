import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/user-premium-plan/user_premium_plan.dart';

class UserPremiumPlansService {
  Future<UserPremiumPlan?> getUserPremiumPlan(
      String token, String userId) async {
    final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/users/$userId/premiumPlan'),
        headers: <String, String>{
          'Authorization': token,
        });

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      if (res.length != 0) {
        return UserPremiumPlan.fromJson(res[0]);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load premium plans');
    }
  }

  Future<Map<String, dynamic>> addUserPremiumPlan(
      String token, String userId, int planId) async {
    final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/users/$userId/premiumPlan'),
        headers: <String, String>{'Authorization': token},
        body: jsonEncode(<String, dynamic>{"planId": planId}));
    if (response.statusCode == 201) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception('Failed to load premium plans');
    }
  }
}
