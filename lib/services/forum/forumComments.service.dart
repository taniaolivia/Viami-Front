import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/forum/forumComments.dart';

class ForumCommentsService {
  Future<ForumComments> getAllCommentsByPostId(String token, int postId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/forum/posts/$postId/comments'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return ForumComments.fromJson(res);
    } else {
      throw ErrorDescription(
          'Échec du chargement des commentaires du post dans le forum');
    }
  }

  Future<Map<String, dynamic>> addCommentToPost(
      String token, String comment, String userId, int postId) async {
    final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/forum/posts/$postId/comments'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode(
            <String, dynamic>{"comment": comment, "userId": userId}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw ErrorDescription(
          "Échec lors d'ajouter un commentaire dans le forum");
    }
  }
}
