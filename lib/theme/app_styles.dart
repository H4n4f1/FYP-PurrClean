import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFFF97316);
  static const primaryLight = Color(0xFFFFA726);
  static const background = Color(0xFFFFF3D6);
  static const toggleTrack = Color(0xFFFCE9C7);
  static const inputFill = Color(0xFFF2F2F4);
  static const textDark = Color(0xFF1E2A44);
  static const textGrey = Color(0xFF8A8FA3);
  static const headerIconBg = Color(0xFFFFF8EF);

  // Home dashboard palette
  static const iconBgOrange = Color(0xFFFCE3C6);
  static const iconBgYellow = Color(0xFFFCE9C7);
  static const iconBgBlue = Color(0xFFDCEAFB);
  static const alertBell = Color(0xFFEF6C3A);
  static const successGreen = Color(0xFF3EBD6A);
  static const infoBlue = Color(0xFF3D6BE0);
  static const moderatePillBg = Color(0xFFFBD98A);
  static const moderatePillText = Color(0xFF8A6300);
  static const barTrack = Color(0xFFE9E9ED);
  static const manualPillBg = Color(0xFFECECF2);
  static const manualPillText = Color(0xFF4B5563);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  // Auto mode toggle button (blue -> teal)
  static const fanGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF3D6BE0), Color(0xFF1FC1C7)],
  );

  // Manual mode toggle button (orange, matches primary palette)
  static const manualGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, primaryLight],
  );

  // "Start Fan" manual-control button
  static const startGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF22C55E), Color(0xFF0D9488)],
  );

  // "Stop Fan" manual-control button
  static const stopGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFEF4444), Color(0xFFF97316)],
  );
}

class AppTextStyles {
  AppTextStyles._();

  static const appTitle = TextStyle(
    fontFamily: 'ComicRelief',
    fontSize: 50,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final fieldLabel = TextStyle(
    fontFamily: 'ComicRelief',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const buttonLabel = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const toggleLabelActive = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const toggleLabelInactive = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const helperText = TextStyle(color: Colors.grey, fontSize: 13);

  static const cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const statLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const statValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const timestamp = TextStyle(fontSize: 12, color: AppColors.textGrey);
}

class AppDecorations {
  AppDecorations._();

  static final cardRadius = BorderRadius.circular(28);
  static final buttonRadius = BorderRadius.circular(16);
  static final inputRadius = BorderRadius.circular(16);
  static final toggleRadius = BorderRadius.circular(16);
  static final toggleButtonRadius = BorderRadius.circular(12);

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500),
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: OutlineInputBorder(
        borderRadius: inputRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: inputRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: inputRadius,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: inputRadius,
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
    );
  }
}