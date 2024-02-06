part of 'premium_plans.dart';

PremiumPlans _$PremiumPlansFromJson(Map<String?, dynamic> json) => PremiumPlans(
      plans: (json['plans'] as List<dynamic>)
          .map((e) => PremiumPlan.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$PremiumPlansToJson(PremiumPlans instance) =>
    <String?, dynamic>{'plans': instance.plans};
