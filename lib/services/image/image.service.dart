import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/image/image.dart';

class ImageService {
  Future<Image> getImageById(String token, String id) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/images/$id'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Image.fromJson(res["data"]);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Image> addImage(String image, String token) async {
    final response =
        await http.post(Uri.parse('${dotenv.env['API_URL']}/image'),
            headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': token,
            },
            body: jsonEncode(<String, dynamic>{"image": image}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Image.fromJson(res["data"]);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String?, dynamic>> updateImageById(
      int imageId, String image, String token) async {
    final response =
        await http.patch(Uri.parse('${dotenv.env['API_URL']}/images/$imageId'),
            headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': token,
            },
            body: jsonEncode(<String, dynamic>{"image": image}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception('Failed to load user');
    }
  }
}
