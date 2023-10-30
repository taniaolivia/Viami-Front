import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/comment/comments.dart';

class CommentsService {
  Future<Comments> getAllComments(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/comments'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Comments.fromJson(res);
    } else {
      throw Exception('Failed to load comments');
    }
  }
}
