import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/activity/activities.dart';

class ActivitiesService {
  Future<Activities> getAllPopularActivities(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/popular/activities'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Activities.fromJson(res);
    } else {
      throw Exception('Failed to load activities');
    }
  }

  Future<Activities> getFivePopularActivities(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/popularFive/activities'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Activities.fromJson(res);
    } else {
      throw Exception('Failed to load activities');
    }
  }
}
