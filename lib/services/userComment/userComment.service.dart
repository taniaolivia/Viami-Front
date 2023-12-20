import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserCommentService {
  Future<bool> hasUserLeftComment(
      String userId, String otherUserId, String token) async {
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}/users/hasUserLeftComment/$userId/$otherUserId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      return res['hasUserLeftComment'] ?? false;
    } else {
      throw ErrorDescription(
          "Échec de vérification du statut du commentaire de l'utilisateur.");
    }
  }

  Future<void> addComment(
      String userId, String commenterId, String comment, String token) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/users/addComment/$userId'),
      headers: <String, String>{'Authorization': token},
      body: {
        'commenterId': commenterId,
        'commentText': comment,
      },
    );

    if (response.statusCode == 200) {
    } else {
      throw ErrorDescription("Échec d'ajout de commentaire");
    }
  }
}
