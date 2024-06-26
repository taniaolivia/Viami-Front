import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  Future<bool> logout(String? id) async {
    final String logoutUrl = '${dotenv.env['API_URL']}/logout/$id';

    try {
      final response = await http.post(
        Uri.parse(logoutUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }
}
