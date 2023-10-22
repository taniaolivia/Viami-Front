import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/image/images.dart';

class ImagesService {
  Future<Images> getAllImages(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/images'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Images.fromJson(res);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
