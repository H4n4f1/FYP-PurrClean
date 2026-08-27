import 'package:flutter/material.dart';
import '../theme/app_styles.dart';

/// Generic white rounded card used throughout the home dashboard.
class DashboardCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const DashboardCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppDecorations.cardShadow,
      ),
      child: child,
    );
  }
}

/// Icon-in-a-circle used as a leading element for card headers and stats.
class RoundIcon extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final double size;

  const RoundIcon({
    super.key,
    required this.icon,
    required this.background,
    required this.iconColor,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: size * 0.5),
    );
  }
}

/// Title row used at the top of most dashboard cards: an icon + a heading.
class CardHeader extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final Widget? trailing;

  const CardHeader({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundIcon(icon: icon, background: iconBg, iconColor: iconColor),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: AppTextStyles.cardTitle)),
        ?trailing,
      ],
    );
  }
}

/// Small rounded pill used for status labels (e.g. "Moderate", "Auto Mode").
class StatusPill extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;

  const StatusPill({
    super.key,
    required this.label,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}