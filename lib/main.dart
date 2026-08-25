import 'package:flutter/material.dart';
import 'analytics_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IoT Analytics',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const AnalyticsScreen(),
    );
  }
}