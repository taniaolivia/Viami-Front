import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/travelComponent.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userDateLocation/usersDateLocation.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userDateLocation/usersDateLocation.service.dart';

class TravelDetailsPage extends StatefulWidget {
  final int travelId;
  final String? date;
  final String? location;
  const TravelDetailsPage(
      {Key? key, required this.travelId, this.date, this.location})
      : super(key: key);

  @override
  State<TravelDetailsPage> createState() => _TravelDetailsPageState();
}

class _TravelDetailsPageState extends State<TravelDetailsPage> {
  final storage = const FlutterSecureStorage();
  String? token;
  String? userId;
  List? users;
  int? nbParticipant;
  bool? tokenExpired;
  String? connectedUserPlan;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");
      //bool isTokenExpired = AuthService().isTokenExpired(token!);

      //tokenExpired = isTokenExpired;

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  Future<UsersDateLocation> getTravelParticipants() {
    Future<UsersDateLocation> getAllParticipantsTravel() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UsersDateLocationService().getAllParticipantsTravel(
          token.toString(), widget.location!, widget.date!);
    }

    return getAllParticipantsTravel();
  }

  Future<void> fetchData() async {
    final participant = await getTravelParticipants();
    final user = await getUser();

    setState(() {
      users = participant.users;
      nbParticipant = participant.nbParticipant;
      connectedUserPlan = user.plan;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return TravelComponent(
        travelId: widget.travelId,
        nbParticipant: nbParticipant,
        users: users,
        location: widget.location,
        date: widget.date,
        connectedUserPlan: connectedUserPlan);
  }
}
