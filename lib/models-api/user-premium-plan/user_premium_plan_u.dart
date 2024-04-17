part of 'user_premium_plan.dart';

UserPremiumPlan _$UserPremiumPlanFromJson(Map<String?, dynamic> json) =>
    UserPremiumPlan(
        id: json['id'],
        userId: json['userId'],
        planId: json['planId'],
        token: json["token"]);

Map<String?, dynamic> _$UserPremiumPlanToJson(UserPremiumPlan instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'planId': instance.planId,
      'token': instance.token
    };
