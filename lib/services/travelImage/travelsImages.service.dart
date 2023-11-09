import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/travelImage/travelsImages.dart';
import 'package:viami/models-api/userImage/usersImages.dart';

class TravelsImagesService {
  Future<TravelsImages> getAllTravelsImages(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/travelImages'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return TravelsImages.fromJson(res['data']);
    } else {
      throw Exception('Failed to load travel images');
    }
  }

  Future<TravelsImages> getTravelImagesById(
      String travelId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/travels/$travelId/images'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return TravelsImages.fromJson(res);
    } else {
      throw Exception('Failed to load travel images');
    }
  }
}
