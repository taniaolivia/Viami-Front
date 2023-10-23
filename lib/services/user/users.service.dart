import 'package:viami/models-api/user/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UsersService {
  Future<Users> getAllUsers(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Users.fromJson(res);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
