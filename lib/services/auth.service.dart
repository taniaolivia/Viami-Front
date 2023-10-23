import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<Map<String?, dynamic>> login(String email, String password) async {
    final response = await http.post(
        Uri.parse("http://localhost:3333/user/login"),
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
    final String baseUrl = 'http://10.0.2.2:3333';

    final String logoutUrl = '$baseUrl/user/logout/$id';

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
}
