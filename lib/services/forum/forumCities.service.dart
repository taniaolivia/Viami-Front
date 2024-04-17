import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/forum/forumCities.dart';

class ForumCitiesService {
  Future<ForumCities> getAllForumCities(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/forum/cities'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return ForumCities.fromJson(res);
    } else {
      throw ErrorDescription(
          'Échec du chargement des villes disponibles dans le forum');
    }
  }
}
