part of 'messages.dart';

Messages _$MessagesFromJson(Map<String?, dynamic> json) => Messages(
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$MessagesToJson(Messages instance) =>
    <String?, dynamic>{'messages': instance.messages};
