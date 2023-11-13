import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/themeActivity/themeActivities.dart';

class ThemesActivitiesService {
  Future<ThemeActivities> getFirstFiveActivitiesByTheme(
      String token, int themeId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/themesFive/$themeId/activities'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return ThemeActivities.fromJson(res);
    } else {
      throw Exception("Failed to load theme's activities");
    }
  }

  Future<ThemeActivities> getAllActivitiesByTheme(
      String token, int themeId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/themes/$themeId/activities'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return ThemeActivities.fromJson(res);
    } else {
      throw Exception("Failed to load theme's activities");
    }
  }
}
