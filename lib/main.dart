import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PurrClean',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFFF8A00),
        scaffoldBackgroundColor: const Color(0xFFFFF3D6),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8A00)),
      ),
      home: const AuthScreen(),
    );
  }
}
