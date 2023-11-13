import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/travelComponent.dart';
import 'package:viami/models-api/userDateLocation/usersDateLocation.dart';
import 'package:viami/services/userDateLocation/usersDateLocation.service.dart';

class TravelPageDetails extends StatefulWidget {
  final int travelId;
  final String? date;
  final String? location;
  const TravelPageDetails(
      {Key? key, required this.travelId, this.date, this.location})
      : super(key: key);

  @override
  State<TravelPageDetails> createState() => _TravelPageDetailsState();
}

class _TravelPageDetailsState extends State<TravelPageDetails> {
  final storage = const FlutterSecureStorage();
  String? token;
  String? userId;
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
        location: widget.location,
        date: widget.date);
  }
}
