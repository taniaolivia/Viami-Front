import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:viami/models-api/messenger/groups_data.dart';

class GroupsService {
  Future<Groups> getAllDiscussionsForUser(String token, String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/discussions/$userId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Groups.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Groups> getTwoUserDiscussions(String token, String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/discussions/twoUsers/$userId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Groups.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Groups> getGroupUsersDiscussions(String token, String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/discussions/groupUsers/$userId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Groups.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Groups> getSearchedUsers(
      String token, String userId, String search) async {
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}/messages/search/users?search=$search&userId=$userId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Groups.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Groups> getGroupUsersDiscussionsByLocation(
      String token, String userId, String location) async {
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}/discussions/$userId/location?location=$location'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Groups.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<String> addUserToGroup(
      String token, String? userToAddId, String groupId) async {
    final response = await http.post(
        Uri.parse(
            '${dotenv.env['API_URL']}/messages/addUserToGroup/$userToAddId/$groupId'),
        headers: <String, String>{
          'Authorization': token,
        });

    if (response.statusCode == 200) {
      var message = "Le voyageur a été ajouté avec succès ";

      return message;
    } else if (response.statusCode == 400) {
      var message = "Le voyageur existe déja dans ce groupe";

      return message;
    } else {
      return "Erreur pendant l'ajout de nouveau utilisateur dans le groupe";
    }
  }

  Future<Groups> getUsersDiscussionsByUnReadFilter(
      String token, String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/discussions/$userId/unread'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Groups.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Groups> getUsersDiscussionsByReadFilter(
      String token, String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/discussions/$userId/read'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Groups.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
