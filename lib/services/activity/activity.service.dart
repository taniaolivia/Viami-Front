import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/activity/activity.dart';

class ActivityService {
  Future<Activity> getActivityById(int activityId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/activities/$activityId'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Activity.fromJson(res["data"][0]);
    } else {
      throw ErrorDescription('Échec du chargement une activité');
    }
  }

  /*Future<void> updateActivityNote(
      int activityId, double newNote, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/newNote/$activityId'),
        headers: <String, String>{'Authorization': token},
        body: {'note': newNote.toString()},
      );

      if (response.statusCode == 200) {
        print('Note mise à jour avec succès');
      } else {
        print('Échec de la mise à jour de la note');
      }
    } catch (error) {
      print('Erreur lors de la mise à jour de la note: $error');
    }
  }*/
}
