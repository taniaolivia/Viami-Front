import 'dart:convert';
import 'package:http/http.dart' as http;
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

  updateImageById(int imageId, List<int> image, String token) async {
    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse('${dotenv.env['API_URL']}/images/$imageId'),
    );
    request.headers['Authorization'] = token;

    var file = http.MultipartFile.fromBytes(
      'image',
      image,
      filename: 'image.jpg',
    );

    request.files.add(file);

    try {
      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        final Map<String, dynamic> decodedResponse = json.decode(response.body);

        print('Decoded Response: $decodedResponse');

        return decodedResponse;
      } else if (response.statusCode == 404) {
        print('Image not found');
        throw Exception('Image not found');
      } else {
        print('Unexpected error: ${response.statusCode}');
        throw Exception('Failed to update image');
      }
    } catch (error) {
      print('Error updating image: $error');
      throw Exception('Failed to update image');
    }
  }
}
