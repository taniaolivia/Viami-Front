import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/requestMessage/request_message.dart';

part 'requests_messages_r.dart';

@JsonSerializable()
class RequestsMessages {
  RequestsMessages({required this.requestsMessages});

  factory RequestsMessages.fromJson(Map<String?, dynamic> json) =>
      _$RequestsMessagesFromJson(json);
  Map<String?, dynamic> toJson() => _$RequestsMessagesToJson(this);

  final List<RequestMessage> requestsMessages;
}
