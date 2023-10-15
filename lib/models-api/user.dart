import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'user.u.dart';

@JsonSerializable()
class User {
  User(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      this.interest,
      this.description,
      required this.location,
      required this.phoneNumber,
      required this.age,
      required this.sex,
      this.lastConnection});

  factory User.fromJson(Map<String?, dynamic> json) => _$UserFromJson(json);
  Map<String?, dynamic> toJson() => _$UserToJson(this);

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? interest;
  final String? description;
  final String location;
  final String phoneNumber;
  final num age;
  final String sex;
  final String? lastConnection;
}

Future<User> register(
    String firstName,
    String lastName,
    String email,
    String passsword,
    String phoneNumber,
    String location,
    num age,
    String sex) async {
  final response =
      await http.post(Uri.parse("http://localhost:3333/user/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": passsword,
            "location": location,
            "phoneNumber": phoneNumber,
            "age": age,
            "sex": sex,
            "lastConnection": ""
          }));

  if (response.statusCode == 200) {
    var res = json.decode(response.body);

    return User.fromJson(res);
  } else {
    throw Exception("Failed to load user");
  }
}

Future<User> getUserById(String id, String token) async {
  final response = await http.get(
    Uri.parse('http://localhost:3333/users/$id'),
    headers: <String, String>{'Authorization': token},
  );

  if (response.statusCode == 200) {
    var res = json.decode(response.body);

    return User.fromJson(res);
  } else {
    throw Exception('Failed to load user');
  }
}
