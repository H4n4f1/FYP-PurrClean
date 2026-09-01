import 'dart:convert';
import 'dart:async';
import '../models/analytics_model.dart';

class ApiService {
  // Simulates fetching analytics data from backend
  static Future<AnalyticsModel> fetchAnalyticsData() async {
    // Simulate a 1.5-second network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Mock JSON response matching our model
    final String mockJsonResponse = '''
    {
      "total_cleanings": 42,
      "waste_weight_kg": 3.8,
      "weekly_usage": [5, 7, 4, 8, 6, 9, 3]
    }
    ''';

    final Map<String, dynamic> decodedData = jsonDecode(mockJsonResponse);
    return AnalyticsModel.fromJson(decodedData);
  }
}