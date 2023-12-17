part of 'requests_messages.dart';

RequestsMessages _$RequestsMessagesFromJson(Map<String?, dynamic> json) =>
    RequestsMessages(
      requestsMessages: (json['requestsMessages'] as List<dynamic>)
          .map((e) => RequestMessage.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$RequestsMessagesToJson(RequestsMessages instance) =>
    <String?, dynamic>{'requestsMessages': instance.requestsMessages};
