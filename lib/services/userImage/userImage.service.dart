import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserImageService {
  Future<Map<String, dynamic>> addUserImage(
      String userId, String imagePath, String token) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("${dotenv.env['API_URL']}/users/$userId/images"));

    request.headers['Authorization'] = token;

    var file = await http.MultipartFile.fromPath('image', imagePath);
    request.files.add(file);

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var res = json.decode(responseBody);
      return res;
    } else {
      throw Exception("Failed to load user image");
    }
  }

  Future<Map<String, dynamic>> deleteUserImage(
      String userId, int imageId, String token, String image) async {
    final response = await http.delete(
        Uri.parse('${dotenv.env['API_URL']}/users/$userId/images'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token
        },
        body:
            jsonEncode(<String, dynamic>{"imageId": imageId, "image": image}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception('Failed to load user image');
    }
  }
}
