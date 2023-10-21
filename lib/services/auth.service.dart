import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  Future<Map<String?, dynamic>> login(String email, String password) async {
    final response = await http.post(
        Uri.parse("${dotenv.env['API_URL']}/login"),
        body: {"email": email, "password": password});

    if (response.statusCode == 200 ||
        response.statusCode == 500 ||
        response.statusCode == 401) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception("Failed to load user");
    }
  }
}
