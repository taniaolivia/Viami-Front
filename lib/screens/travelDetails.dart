import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/travelComponent.dart';
import 'package:viami/models-api/userDateLocation/usersDateLocation.dart';
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

    setState(() {
      users = participant.users;
      nbParticipant = participant.nbParticipant;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TravelComponent(
        travelId: widget.travelId,
        nbParticipant: nbParticipant,
        users: users,
        location: widget.location,
        date: widget.date);
  }
}
