import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // 0 = Daily, 1 = Weekly, 2 = Monthly
  int _selectedTimeframe = 0;

  // Label Data Arrays
  final List<String> _dailyLabels = ['12am', '4am', '8am', '12pm', '4pm', '8pm'];
  final List<String> _weeklyLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _monthlyLabels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];

  List<String> get _currentLabels {
    if (_selectedTimeframe == 0) return _dailyLabels;
    if (_selectedTimeframe == 1) return _weeklyLabels;
    return _monthlyLabels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EE),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Behavioral Analytics',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeframeToggle(),
            const SizedBox(height: 20),

            // Chart 1: Visit Pattern / Frequency
            _buildCard(
              title: _selectedTimeframe == 0
                  ? 'Daily Visit Frequency'
                  : _selectedTimeframe == 1
                      ? 'Weekly Visit Pattern'
                      : 'Monthly Visit Overview',
              child: SizedBox(
                height: 200,
                child: _selectedTimeframe == 0
                    ? _buildDailyLineChart()
                    : _buildBarChart(Colors.blue),
              ),
            ),
            const SizedBox(height: 16),

            // Chart 2: Visit Duration
            _buildCard(
              title: 'Visit Duration (min)',
              child: SizedBox(
                height: 200,
                child: _buildBarChart(Colors.teal),
              ),
            ),
            const SizedBox(height: 16),

            // Chart 3: Waste Accumulation
            _buildCard(
              title: 'Waste Accumulation (grams)',
              child: SizedBox(
                height: 200,
                child: _buildWasteAreaChart(),
              ),
            ),
            const SizedBox(height: 20),

            // Behavioral Insights
            const Text(
              'Behavioral Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              title: 'Abnormal Frequency Detected',
              subtitle: 'Visit frequency increased by 35% today.',
              badgeText: 'high',
              badgeColor: Colors.red,
            ),
            _buildInsightCard(
              title: 'Pattern Change',
              subtitle: 'Evening visits account for 40% of activity.',
              badgeText: 'medium',
              badgeColor: Colors.amber,
            ),
            const SizedBox(height: 16),

            // Summary Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Avg Visits',
                    value: '0.7',
                    subtext: '↓ 12% vs last period',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Avg Duration',
                    value: '3.5 min',
                    subtext: 'Stable',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Toggle Bar (Daily / Weekly / Monthly)
  Widget _buildTimeframeToggle() {
    final options = ['Daily', 'Weekly', 'Monthly'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(options.length, (index) {
          final isSelected = _selectedTimeframe == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTimeframe = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                options[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Common X-Axis Bottom Titles Config
  AxisTitles _buildBottomTitles() {
    final labels = _currentLabels;
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          if (index >= 0 && index < labels.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                labels[index],
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Line Chart for Daily
  Widget _buildDailyLineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: _buildBottomTitles(),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 2.1),
              FlSpot(2, 1),
              FlSpot(3, 3),
              FlSpot(4, 2.1),
              FlSpot(5, 0.5),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  // Bar Chart for Weekly / Monthly / Duration
  Widget _buildBarChart(Color color) {
    final labels = _currentLabels;
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: _buildBottomTitles(),
        ),
        barGroups: List.generate(labels.length, (index) {
          // Sample dummy values matching array lengths
          final values = [4.0, 6.0, 3.0, 7.0, 5.0, 8.0, 4.0];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: values[index % values.length],
                color: color,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Area Chart for Waste Accumulation
  Widget _buildWasteAreaChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: _buildBottomTitles(),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(_currentLabels.length, (index) {
              final yValues = [50.0, 80.0, 120.0, 160.0, 210.0, 250.0, 290.0];
              return FlSpot(index.toDouble(), yValues[index % yValues.length]);
            }),
            isCurved: true,
            color: Colors.amber,
            barWidth: 2,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.amber.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(badgeText, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle),
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required String subtext}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
          const SizedBox(height: 4),
          Text(subtext, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}