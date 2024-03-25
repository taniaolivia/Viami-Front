import 'package:json_annotation/json_annotation.dart';

part 'user_premium_plan_u.dart';

@JsonSerializable()
class UserPremiumPlan {
  final int id;
  final String userId;
  final int planId;
  final String token;

  UserPremiumPlan({
    required this.id,
    required this.userId,
    required this.planId,
    required this.token,
  });

  factory UserPremiumPlan.fromJson(Map<String?, dynamic> json) =>
      _$UserPremiumPlanFromJson(json);
  Map<String?, dynamic> toJson() => _$UserPremiumPlanToJson(this);
}
