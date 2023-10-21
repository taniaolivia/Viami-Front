import 'package:viami/models-api/userInterest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserInterestService {
  Future<Map<String, dynamic>> addUserInterest(
      String userId, int interestId, String token) async {
    final response = await http.post(
        Uri.parse("${dotenv.env['API_URL']}/users/$userId/interests"),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token
        },
        body: jsonEncode(<String, dynamic>{"interestId": interestId}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<Map<String, dynamic>> deleteUserInterest(
      String userId, int interestId, String token) async {
    final response = await http.delete(
        Uri.parse('${dotenv.env['API_URL']}/users/$userId/interests'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token
        },
        body: jsonEncode(<String, dynamic>{"interestId": interestId}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception('Failed to load user');
    }
  }
}
