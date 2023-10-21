import 'package:json_annotation/json_annotation.dart';

part 'interest.i.dart';

@JsonSerializable()
class Interest {
  Interest({this.id, required this.interest, this.message});

  factory Interest.fromJson(Map<String?, dynamic> json) =>
      _$InterestFromJson(json);
  Map<String?, dynamic> toJson() => _$InterestToJson(this);

  final int? id;
  final String interest;
  final String? message;
}
