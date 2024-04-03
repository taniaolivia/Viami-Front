import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/forum/forumPostsCity.dart';

class ForumPostsCitiesService {
  Future<ForumPostsCity> getAllPostsByCityId(String token, int cityId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/forum/posts_cities/$cityId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return ForumPostsCity.fromJson(res);
    } else {
      throw ErrorDescription(
          'Échec du chargement des posts dans le forum de cette ville');
    }
  }

  Future<Map<String, dynamic>> addPostToForumCity(
      String token, String post, String userId, int cityId) async {
    final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/forum/posts_cities/$cityId'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode(<String, dynamic>{"post": post, "userId": userId}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw ErrorDescription(
          "Échec lors d'ajouter un post dans le forum de cette ville");
    }
  }
}
