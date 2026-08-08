import 'package:flutter/material.dart';

/// Central place for all colors, text styles, and shared decoration values
/// used across the PurrClean UI. This is the closest Flutter equivalent to
/// a CSS stylesheet — pull new colors/styles out here as the app grows,
/// instead of hardcoding them inside widgets.
class AppColors {
  AppColors._();

  static const primary = Color(0xFFF97316);
  static const primaryLight = Color(0xFFFFA726);
  static const background = Color(0xFFFFF3D6);
  static const toggleTrack = Color(0xFFFCE9C7);
  static const inputFill = Color(0xFFF2F2F4);
  static const textDark = Color(0xFF1E2A44);
  static const headerIconBg = Color(0xFFFFF8EF);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );
}

class AppTextStyles {
  AppTextStyles._();

  static const appTitle = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const appSubtitle = TextStyle(fontSize: 16, color: Colors.white);

  static const fieldLabel = TextStyle(
    fontSize: 15,
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
      color: Colors.black.withOpacity(0.08),
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
