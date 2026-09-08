class AnalyticsModel {
  final int totalCleanings;
  final double wasteWeightKg;
  final List<int> weeklyUsage;

  AnalyticsModel({
    required this.totalCleanings,
    required this.wasteWeightKg,
    required this.weeklyUsage,
  });

  // Factory constructor to convert raw JSON into a Dart object
  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      totalCleanings: json['total_cleanings'] ?? 0,
      wasteWeightKg: (json['waste_weight_kg'] ?? 0.0).toDouble(),
      weeklyUsage: List<int>.from(json['weekly_usage'] ?? []),
    );
  }
}