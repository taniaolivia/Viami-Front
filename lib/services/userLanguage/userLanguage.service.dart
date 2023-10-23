import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserLanguageService {
  Future<Map<String, dynamic>> addUserLanguage(
      String userId, int languageId, String token) async {
    final response = await http.post(
        Uri.parse("${dotenv.env['API_URL']}/users/$userId/languages"),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token
        },
        body: jsonEncode(<String, dynamic>{"languageId": languageId}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception("Failed to load user language");
    }
  }

  Future<Map<String, dynamic>> deleteUserLanguage(
      String userId, int languageId, String token) async {
    final response = await http.delete(
        Uri.parse('${dotenv.env['API_URL']}/users/$userId/languages'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token
        },
        body: jsonEncode(<String, dynamic>{"languageId": languageId}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception('Failed to load user language');
    }
  }
}
