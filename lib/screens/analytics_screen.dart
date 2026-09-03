import 'package:flutter/material.dart';
import '../theme/app_styles.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/analytics_chart.dart';

/// Which time range the Behavioral Analytics screen is currently showing.
enum AnalyticsPeriod { daily, weekly, monthly }

/// Placeholder insight model.
/// TODO: Replace with real insights computed by the backend once it's ready.
class BehavioralInsight {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String severity; // 'high' | 'medium' | 'low'
  final String description;

  const BehavioralInsight({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.severity,
    required this.description,
  });
}

/// Static per-period chart/axis configuration (labels, scales, titles).
/// Only the shape of the charts lives here — the actual numbers are wired
/// in separately once the backend is ready.
class _PeriodConfig {
  final List<String> xLabels;

  final String visitChartTitle;
  final ChartType visitChartType;
  final double visitMaxY;

  final String durationChartTitle;
  final ChartType durationChartType;
  final double durationMaxY;

  final String wasteChartTitle;
  final double wasteMaxY;

  final String avgVisitsLabel;
  final String avgVisitsSubtitle;
  final String avgDurationSubtitle;

  const _PeriodConfig({
    required this.xLabels,
    required this.visitChartTitle,
    required this.visitChartType,
    required this.visitMaxY,
    required this.durationChartTitle,
    required this.durationChartType,
    required this.durationMaxY,
    required this.wasteChartTitle,
    required this.wasteMaxY,
    required this.avgVisitsLabel,
    required this.avgVisitsSubtitle,
    required this.avgDurationSubtitle,
  });
}

const Map<AnalyticsPeriod, _PeriodConfig> _periodConfigs = {
  AnalyticsPeriod.daily: _PeriodConfig(
    xLabels: ['12AM', '4AM', '8AM', '12PM', '4PM', '8PM'],
    visitChartTitle: 'Visit Frequency',
    visitChartType: ChartType.area,
    visitMaxY: 2,
    durationChartTitle: 'Visit Duration (min)',
    durationChartType: ChartType.line,
    durationMaxY: 8,
    wasteChartTitle: 'Waste Accumulation (grams)',
    wasteMaxY: 220,
    avgVisitsLabel: 'Avg Hourly Visits',
    avgVisitsSubtitle: 'No data yet',
    avgDurationSubtitle: 'No data yet',
  ),
  AnalyticsPeriod.weekly: _PeriodConfig(
    xLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    visitChartTitle: 'Visit Frequency',
    visitChartType: ChartType.bar,
    visitMaxY: 8,
    durationChartTitle: 'Visit Duration (min)',
    durationChartType: ChartType.bar,
    durationMaxY: 28,
    wasteChartTitle: 'Waste Accumulation (grams)',
    wasteMaxY: 200,
    avgVisitsLabel: 'Avg Daily Visits',
    avgVisitsSubtitle: 'No data yet',
    avgDurationSubtitle: 'No data yet',
  ),
  AnalyticsPeriod.monthly: _PeriodConfig(
    xLabels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
    visitChartTitle: 'Visit Frequency',
    visitChartType: ChartType.bar,
    visitMaxY: 60,
    durationChartTitle: 'Visit Duration (min)',
    durationChartType: ChartType.bar,
    durationMaxY: 180,
    wasteChartTitle: 'Waste Accumulation (grams)',
    wasteMaxY: 1200,
    avgVisitsLabel: 'Avg Weekly Visits',
    avgVisitsSubtitle: 'No data yet',
    avgDurationSubtitle: 'No data yet',
  ),
};

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  AnalyticsPeriod _selectedPeriod = AnalyticsPeriod.daily;

  // ---------------------------------------------------------------------
  // MOCK DATA — everything below is left empty on purpose.
  // TODO: Replace with real data from the backend once it's ready.
  // ---------------------------------------------------------------------
  final List<double> visitValues = const [];
  final List<double> durationValues = const [];
  final List<double> wasteValues = const [];

  final String avgVisitsValue = '-';
  final String avgDurationValue = '-';

  final List<BehavioralInsight> insights = const [];
  // ---------------------------------------------------------------------

  _PeriodConfig get _config => _periodConfigs[_selectedPeriod]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildPeriodSelector(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildChartCard(
                      title: _config.visitChartTitle,
                      chart: AnalyticsChart(
                        type: _config.visitChartType,
                        values: visitValues,
                        xLabels: _config.xLabels,
                        maxY: _config.visitMaxY,
                        color: AppColors.infoBlue,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildChartCard(
                      title: _config.durationChartTitle,
                      chart: AnalyticsChart(
                        type: _config.durationChartType,
                        values: durationValues,
                        xLabels: _config.xLabels,
                        maxY: _config.durationMaxY,
                        color: AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildChartCard(
                      title: _config.wasteChartTitle,
                      chart: AnalyticsChart(
                        type: ChartType.area,
                        values: wasteValues,
                        xLabels: _config.xLabels,
                        maxY: _config.wasteMaxY,
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildInsightsCard(),
                    const SizedBox(height: 18),
                    _buildSummaryRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -- Header -------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 56),
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -30,
            right: -40,
            child: _decorCircle(150, Colors.white.withValues(alpha: 0.08)),
          ),
          Positioned(
            top: 40,
            right: 30,
            child: _decorCircle(90, Colors.white.withValues(alpha: 0.10)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.of(context).maybePop(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Behavioral Analytics',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  // -- Period selector ------------------------------------------------------

  Widget _buildPeriodSelector() {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDecorations.toggleRadius,
        boxShadow: AppDecorations.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _periodButton('Daily', AnalyticsPeriod.daily),
          ),
          Expanded(
            child: _periodButton('Weekly', AnalyticsPeriod.weekly),
          ),
          Expanded(
            child: _periodButton('Monthly', AnalyticsPeriod.monthly),
          ),
        ],
      ),
    );
  }

  Widget _periodButton(String label, AnalyticsPeriod period) {
    final selected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        // TODO: Fetch analytics data for the newly selected period.
        setState(() => _selectedPeriod = period);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: selected ? AppColors.manualGradient : null,
          borderRadius: AppDecorations.toggleButtonRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: selected
              ? AppTextStyles.toggleLabelActive
              : AppTextStyles.toggleLabelInactive,
        ),
      ),
    );
  }

  // -- Chart card -----------------------------------------------------------

  Widget _buildChartCard({required String title, required Widget chart}) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 20),
          chart,
        ],
      ),
    );
  }

  // -- Behavioral insights ----------------------------------------------------

  Widget _buildInsightsCard() {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardHeader(
            icon: Icons.trending_up_rounded,
            iconBg: AppColors.iconBgOrange,
            iconColor: AppColors.primary,
            title: 'Behavioral Insights',
          ),
          const SizedBox(height: 18),
          if (insights.isEmpty)
            Text(
              'No insights yet — check back once your device starts collecting data.',
              style: TextStyle(color: Colors.grey.shade600, height: 1.4),
            )
          else
            Column(
              children: [
                for (int i = 0; i < insights.length; i++) ...[
                  _buildInsightRow(insights[i]),
                  if (i != insights.length - 1) const SizedBox(height: 14),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(BehavioralInsight insight) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(insight.icon, color: insight.iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        insight.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    _severityPill(insight.severity),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: TextStyle(color: Colors.grey.shade600, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _severityPill(String severity) {
    late final Color bg;
    late final Color text;
    switch (severity) {
      case 'high':
        bg = const Color(0xFFE0294A);
        text = Colors.white;
        break;
      case 'medium':
        bg = const Color(0xFFE7ECFB);
        text = const Color(0xFF475569);
        break;
      default:
        bg = const Color(0xFF15192B);
        text = Colors.white;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        severity,
        style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  // -- Summary row -----------------------------------------------------------

  Widget _buildSummaryRow() {
    return Row(
      children: [
        _buildSummaryCard(
          label: _config.avgVisitsLabel,
          value: avgVisitsValue,
          subtitle: _config.avgVisitsSubtitle,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          label: 'Avg Duration',
          value: avgDurationValue,
          subtitle: _config.avgDurationSubtitle,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required String subtitle,
  }) {
    return Expanded(
      child: DashboardCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}