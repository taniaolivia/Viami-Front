import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserImageService {
  Future<Map<String, dynamic>> addUserImage(
      String userId, String imagePath, String token) async {
    final response = await http.post(
        Uri.parse("${dotenv.env['API_URL']}/users/$userId/images"),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token
        },
        body: jsonEncode(<String, dynamic>{"image": imagePath}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      return res;
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<Map<String, dynamic>> deleteUserImage(
      String userId, int imageId, String token) async {
    final response = await http.delete(
        Uri.parse('${dotenv.env['API_URL']}/users/$userId/images'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token
        },
        body: jsonEncode(<String, dynamic>{"imageId": imageId}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception('Failed to load user');
    }
  }
}
