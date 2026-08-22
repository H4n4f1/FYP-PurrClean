import 'package:flutter/material.dart';
import '../theme/app_styles.dart';
import 'dashboard_card.dart';

/// One tile of the home dashboard's 2x2 stat grid.
///
/// [value] is the big headline text (e.g. "68%", "2 hours ago").
/// [trailing] is optional extra content next to the value (trend arrow, pill, etc).
class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String? value;
  final Widget? trailing;

  /// Use instead of [value] when the headline needs custom styling
  /// (e.g. a status pill rather than plain text).
  final Widget? valueWidget;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    this.value,
    this.valueWidget,
    this.trailing,
  }) : assert(
         value != null || valueWidget != null,
         'Provide either value or valueWidget',
       );

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RoundIcon(
                icon: icon,
                background: iconBg,
                iconColor: iconColor,
                size: 38,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.statLabel,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Flexible(
                child:
                    valueWidget ??
                    Text(
                      value!,
                      style: AppTextStyles.statValue,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              if (trailing != null) ...[const SizedBox(width: 6), trailing!],
            ],
          ),
        ],
      ),
    );
  }
}