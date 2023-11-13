import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/activity/activities.dart';

class RecommendedActivitiesService {
  Future<Activities> getAllRecommendedActivities(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/recommend/activities'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Activities.fromJson(res);
    } else {
      throw Exception('Failed to load recommended activities');
    }
  }

  Future<Activities> getFiveRecommendedActivities(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/recommendFive/activities'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Activities.fromJson(res);
    } else {
      throw Exception('Failed to load recommended activities');
    }
  }

  Future<Activities> getRecommendActivityById(
      int activityId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/recommend/activities/$activityId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Activities.fromJson(res['activity'][0]);
    } else {
      throw Exception('Failed to load activity');
    }
  }
}
