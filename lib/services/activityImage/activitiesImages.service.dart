import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/activityImage/activitiesImages.dart';

class ActivitiesImagesService {
  Future<ActivitiesImages> getAllActivitiesImages(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/activitiesImages'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return ActivitiesImages.fromJson(res['data']);
    } else {
      throw Exception('Failed to load activity images');
    }
  }

  Future<ActivitiesImages> getActivityImagesById(
      int activityId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/activities/$activityId/images'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return ActivitiesImages.fromJson(res);
    } else {
      throw Exception('Failed to load activity images');
    }
  }
}
