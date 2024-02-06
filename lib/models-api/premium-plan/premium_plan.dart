import 'package:json_annotation/json_annotation.dart';

part 'premium_plan_p.dart';

@JsonSerializable()
class PremiumPlan {
  final int id;
  final String plan;
  final String price;
  final String by;
  final String description;
  final int popular;

  PremiumPlan({
    required this.id,
    required this.plan,
    required this.price,
    required this.by,
    required this.description,
    required this.popular,
  });

  factory PremiumPlan.fromJson(Map<String?, dynamic> json) =>
      _$PremiumPlanFromJson(json);
  Map<String?, dynamic> toJson() => _$PremiumPlanToJson(this);
}
