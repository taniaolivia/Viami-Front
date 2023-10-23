import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/userImage/usersImages.dart';

class UsersImagesService {
  Future<UsersImages> getAllUsersImages(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/usersImages'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return UsersImages.fromJson(res['data']);
    } else {
      throw Exception('Failed to load user images');
    }
  }

  Future<UsersImages> getUserImagesById(String userId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/$userId/images'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return UsersImages.fromJson(res);
    } else {
      throw Exception('Failed to load user images');
    }
  }
}
