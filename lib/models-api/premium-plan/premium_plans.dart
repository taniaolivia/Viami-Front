import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/premium-plan/premium_plan.dart';

part 'premium_plans_p.dart';

@JsonSerializable()
class PremiumPlans {
  final List<PremiumPlan> plans;

  PremiumPlans({required this.plans});

  factory PremiumPlans.fromJson(Map<String?, dynamic> json) =>
      _$PremiumPlansFromJson(json);
  Map<String?, dynamic> toJson() => _$PremiumPlansToJson(this);
}
