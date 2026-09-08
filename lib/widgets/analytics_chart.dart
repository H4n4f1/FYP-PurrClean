import 'package:flutter/material.dart';

/// Visual style used to render an [AnalyticsChart].
enum ChartType { bar, line, area }

/// A small, dependency-free chart used on the Behavioral Analytics screen.
///
/// Pass an empty (or all-zero) [values] list to render just the axes/grid as
/// a placeholder — that's what the screen does today, since the real numbers
/// will come from the backend later. Once real data is wired in, the same
/// widget will plot bars / a line / a filled area automatically.
class AnalyticsChart extends StatelessWidget {
  final ChartType type;
  final List<double> values;
  final List<String> xLabels;
  final double maxY;
  final int yDivisions;
  final Color color;
  final double height;
  final String Function(double value)? yLabelBuilder;

  const AnalyticsChart({
    super.key,
    required this.type,
    required this.values,
    required this.xLabels,
    required this.maxY,
    required this.color,
    this.yDivisions = 4,
    this.height = 210,
    this.yLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _AnalyticsChartPainter(
          type: type,
          values: values,
          xLabels: xLabels,
          maxY: maxY <= 0 ? 1 : maxY,
          yDivisions: yDivisions,
          color: color,
          yLabelBuilder: yLabelBuilder ?? _defaultYLabel,
        ),
      ),
    );
  }

  static String _defaultYLabel(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}

class _AnalyticsChartPainter extends CustomPainter {
  final ChartType type;
  final List<double> values;
  final List<String> xLabels;
  final double maxY;
  final int yDivisions;
  final Color color;
  final String Function(double value) yLabelBuilder;

  _AnalyticsChartPainter({
    required this.type,
    required this.values,
    required this.xLabels,
    required this.maxY,
    required this.yDivisions,
    required this.color,
    required this.yLabelBuilder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 40.0;
    const bottomPad = 24.0;
    final chartWidth = size.width - leftPad;
    final chartHeight = size.height - bottomPad;
    if (chartWidth <= 0 || chartHeight <= 0) return;

    final gridPaint = Paint()
      ..color = const Color(0xFFE9E9ED)
      ..strokeWidth = 1;
    final labelStyle = TextStyle(color: Colors.grey.shade500, fontSize: 11);

    // Horizontal grid lines + y-axis labels.
    for (int i = 0; i <= yDivisions; i++) {
      final y = chartHeight - (chartHeight / yDivisions) * i;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
      final labelValue = (maxY / yDivisions) * i;
      final tp = TextPainter(
        text: TextSpan(text: yLabelBuilder(labelValue), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPad - tp.width - 8, y - tp.height / 2));
    }

    // X-axis labels.
    final n = xLabels.length;
    if (n > 0) {
      for (int i = 0; i < n; i++) {
        final x = leftPad + (chartWidth / n) * (i + 0.5);
        final tp = TextPainter(
          text: TextSpan(text: xLabels[i], style: labelStyle),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, chartHeight + 6));
      }
    }

    // No data yet — leave the placeholder grid empty until the backend
    // supplies real values.
    final hasData = values.isNotEmpty && values.any((v) => v > 0);
    if (!hasData) return;

    switch (type) {
      case ChartType.bar:
        _drawBars(canvas, leftPad, chartWidth, chartHeight);
        break;
      case ChartType.line:
        _drawLineOrArea(canvas, leftPad, chartWidth, chartHeight, fill: false);
        break;
      case ChartType.area:
        _drawLineOrArea(canvas, leftPad, chartWidth, chartHeight, fill: true);
        break;
    }
  }

  void _drawBars(
    Canvas canvas,
    double leftPad,
    double chartWidth,
    double chartHeight,
  ) {
    final n = values.length;
    if (n == 0) return;
    final slot = chartWidth / n;
    final barWidth = slot * 0.55;
    final paint = Paint()..color = color;
    for (int i = 0; i < n; i++) {
      final v = values[i].clamp(0.0, maxY);
      final barHeight = chartHeight * (v / maxY);
      final x = leftPad + slot * i + (slot - barWidth) / 2;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, chartHeight - barHeight, barWidth, barHeight),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  void _drawLineOrArea(
    Canvas canvas,
    double leftPad,
    double chartWidth,
    double chartHeight, {
    required bool fill,
  }) {
    final n = values.length;
    if (n == 0) return;
    final points = <Offset>[];
    for (int i = 0; i < n; i++) {
      final x = n == 1
          ? leftPad + chartWidth / 2
          : leftPad + (chartWidth / (n - 1)) * i;
      final v = values[i].clamp(0.0, maxY);
      final y = chartHeight - chartHeight * (v / maxY);
      points.add(Offset(x, y));
    }

    if (fill) {
      final fillPath = Path()..moveTo(points.first.dx, chartHeight);
      for (final p in points) {
        fillPath.lineTo(p.dx, p.dy);
      }
      fillPath.lineTo(points.last.dx, chartHeight);
      fillPath.close();
      final fillPaint = Paint()..color = color.withValues(alpha: 0.25);
      canvas.drawPath(fillPath, fillPaint);
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    if (!fill) {
      final dotFillPaint = Paint()..color = Colors.white;
      final dotStrokePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      for (final p in points) {
        canvas.drawCircle(p, 4, dotFillPaint);
        canvas.drawCircle(p, 4, dotStrokePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AnalyticsChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.type != type ||
        oldDelegate.color != color ||
        oldDelegate.maxY != maxY ||
        oldDelegate.xLabels != xLabels;
  }
}