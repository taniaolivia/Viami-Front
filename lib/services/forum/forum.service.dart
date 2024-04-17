import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/forum/forum.dart';

class ForumService {
  Future<Forum> getAllPostsForum(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/forum/posts'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Forum.fromJson(res);
    } else {
      throw ErrorDescription('Échec du chargement des posts dans le forum');
    }
  }

  Future<Forum> getAllNewestPostsForum(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/forum/posts/newest'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Forum.fromJson(res);
    } else {
      throw ErrorDescription('Échec du chargement des posts dans le forum');
    }
  }

  Future<Forum> getAllOldestPostsForum(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/forum/posts/oldest'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Forum.fromJson(res);
    } else {
      throw ErrorDescription('Échec du chargement des posts dans le forum');
    }
  }

  Future<Map<String, dynamic>> addPostForum(
      String token, String post, String userId) async {
    final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/forum/posts'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode(<String, dynamic>{"post": post, "userId": userId}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw ErrorDescription('Échec du chargement des posts dans le forum');
    }
  }
}
