import 'package:flutter/material.dart';
<<<<<<< dashboardv2
import 'package:care_alert/presentation/components/layout.dart';
=======
>>>>>>> master
import 'package:get/get.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< dashboardv2
    return LayoutPage(
      child: DashboardContent(),
=======
    final textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: const Color(0xFFF3F3F3),
      child: SafeArea(
        child: Column(
          children: [
            const DashboardTopHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'dashboard'.tr,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'dashboard_welcome_subtitle'.tr,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4E4E4E),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        DashboardActionButton(
                          backgroundColor: const Color(0xFF1F66FF),
                          label: 'new_melding'.tr,
                          icon: Icons.note_add_outlined,
                          onPressed: () {},
                        ),
                        DashboardActionButton(
                          backgroundColor: const Color(0xFFE10019),
                          label: 'dashboard_emergency_alert'.tr,
                          icon: Icons.warning_amber_rounded,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    DashboardStatsCard(
                      count: 3,
                      title: 'dashboard_alerts_today'.tr,
                      tagLabel: 'dashboard_tag_today'.tr,
                      baseColor: Color(0xFF1A66F8),
                      highlightColor: Color(0xFF1A66F8),
                      leadingIcon: Icons.north_east_rounded,
                    ),
                    const SizedBox(height: 14),
                    DashboardStatsCard(
                      count: 2,
                      title: 'dashboard_open_alerts'.tr,
                      tagLabel: 'dashboard_tag_active'.tr,
                      baseColor: Color(0xFFE5001A),
                      highlightColor: Color(0xFFE5001A),
                      leadingIcon: Icons.watch_later_outlined,
                    ),
                    const SizedBox(height: 14),
                    DashboardStatsCard(
                      count: 1,
                      title: 'dashboard_high_priority'.tr,
                      tagLabel: 'dashboard_tag_active'.tr,
                      baseColor: Color(0xFFF56800),
                      highlightColor: Color(0xFFF56800),
                      leadingIcon: Icons.monitor_heart_outlined,
                    ),
                    const SizedBox(height: 14),
                    DashboardStatsCard(
                      count: 3,
                      title: 'dashboard_resolved'.tr,
                      tagLabel: 'dashboard_tag_completed'.tr,
                      baseColor: Color(0xFF05B946),
                      highlightColor: Color(0xFF05B946),
                      leadingIcon: Icons.check_circle_outline,
                    ),
                    const SizedBox(height: 20),
                    const DashboardWeeklyTrendCard(),
                    const SizedBox(height: 20),
                    const DashboardSeverityDistributionCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
>>>>>>> master
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> hoofdMeldingen = [
    {
      'id': 'zorg',
      'titleKey': 'dashboard_card_care_title',
      'subtitleKey': 'dashboard_card_care_subtitle',
      'descriptionKey': 'dashboard_card_care_description',
      'icon': Icons.favorite,
      'color': Colors.pink,
      'bgColor': Color(0xFFFFF1F3),
      'borderColor': Color(0xFFF8BBD0),
      'iconBg': Color(0xFFF8BBD0),
      'iconColor': Color(0xFFD81B60),
      'category': 'zorg',
    },
    {
      'id': 'facilitair',
      'titleKey': 'dashboard_card_facility_title',
      'subtitleKey': 'dashboard_card_facility_subtitle',
      'descriptionKey': 'dashboard_card_facility_description',
      'icon': Icons.apartment,
      'color': Colors.blue,
      'bgColor': Color(0xFFE3F2FD),
      'borderColor': Color(0xFF90CAF9),
      'iconBg': Color(0xFF90CAF9),
      'iconColor': Color(0xFF1976D2),
      'category': 'facilitair',
    },
  ];

  void handleMeldingClick(BuildContext context, String category) {
    Navigator.pushNamed(context, '/nieuwe-melding', arguments: {'category': category});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:const  AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
<<<<<<< dashboardv2
          // Header
          Column(
=======
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.mark_email_unread_rounded,
              color: Color(0xFF2D6BFF),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> master
            children: [
              const SizedBox(height: 16),
              Text(
<<<<<<< dashboardv2
                'dashboard_welcome'.tr,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
=======
                'dashboard_brand_name'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
>>>>>>> master
              ),
              const SizedBox(height: 8),
              Text(
<<<<<<< dashboardv2
                'dashboard_question'.tr,
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'textHint'.tr,
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
=======
                'dashboard_brand_subtitle'.tr,
                style: TextStyle(
                  color: Color(0xFFD8E5FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
>>>>>>> master
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Nieuwe Melding
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'dashboard_new_report'.tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
            mainAxisSpacing: 12,
            children: hoofdMeldingen.map((type) {
              return GestureDetector(
                onTap: () => handleMeldingClick(context, type['category']),
                child: Card(
                  color: type['bgColor'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: type['borderColor']),
                  ),
<<<<<<< dashboardv2
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: type['iconBg'],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          width: 56,
                          height: 56,
                          child: Icon(type['icon'], color: type['iconColor'], size: 32),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          (type['titleKey'] as String).tr,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          (type['subtitleKey'] as String).tr,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          (type['descriptionKey'] as String).tr,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
=======
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.32),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tagLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  height: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardWeeklyTrendCard extends StatelessWidget {
  const DashboardWeeklyTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    const points = [3.0, 2.0, 4.0, 1.0, 5.0, 2.0, 3.0];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'dashboard_alerts_this_week'.tr,
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF001B44),
>>>>>>> master
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Info sectie
          Card(
            color: Colors.blue[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.blue),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
<<<<<<< dashboardv2
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
=======
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8E7FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'dashboard_week'.tr,
                      style: TextStyle(
                        color: Color(0xFF1D63F0),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
>>>>>>> master
                    ),
                    child: const Center(child: Text('💡', style: TextStyle(fontSize: 24))),
                  ),
<<<<<<< dashboardv2
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('dashboard_how_it_works'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('dashboard_step_1'.tr),
                        Text('dashboard_step_2'.tr),
                        Text('dashboard_step_3'.tr),
                        Text('dashboard_step_4'.tr),
                        const SizedBox(height: 8),
                        Text(
                          'dashboard_auto_info'.tr,
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Snelle toegang
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/meldingen'),
                  icon: const Icon(Icons.description),
                  label: Text('dashboard_my_reports'.tr),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/rapportages'),
                  icon: const Icon(Icons.access_time),
                  label: Text('dashboard_soap_reports'.tr),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
=======
                  const SizedBox(width: 8),
                  Text(
                    'dashboard_month'.tr,
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'dashboard_alerts_trend_subtitle'.tr,
            style: TextStyle(
              color: Color(0xFF49618A),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          AspectRatio(
            aspectRatio: 1.65,
            child: CustomPaint(
              painter: _WeeklyLineChartPainter(values: points),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardSeverityDistributionCard extends StatelessWidget {
  const DashboardSeverityDistributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    const low = 3;
    const medium = 2;
    const high = 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dashboard_severity_distribution'.tr,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
              color: Color(0xFF001B44),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'dashboard_distribution_subtitle'.tr,
            style: TextStyle(
              color: Color(0xFF49618A),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          const Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: CustomPaint(
                painter: _SeverityDonutPainter(
                  low: low,
                  medium: medium,
                  high: high,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _LegendRow(
            color: Color(0xFF10B981),
            label: 'severity_low'.tr,
            value: low,
          ),
          const SizedBox(height: 6),
          _LegendRow(
            color: Color(0xFFF59E0B),
            label: 'severity_medium'.tr,
            value: medium,
          ),
          const SizedBox(height: 6),
          _LegendRow(
            color: Color(0xFFEF4444),
            label: 'severity_high'.tr,
            value: high,
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1F3559),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '$value',
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _WeeklyLineChartPainter extends CustomPainter {
  const _WeeklyLineChartPainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    const axisColor = Color(0xFF94A3B8);
    const gridColor = Color(0xFFD7DCE4);
    const lineColor = Color(0xFF3D7EEB);

    final chartRect = Rect.fromLTRB(42, 14, size.width - 12, size.height - 30);
    final yMax = 8.0;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 4; i++) {
      final y = chartRect.bottom - (i / 4) * chartRect.height;
      _drawDashedLine(
        canvas,
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

    for (int i = 0; i < 7; i++) {
      final x = chartRect.left + i * (chartRect.width / 6);
      _drawDashedLine(
        canvas,
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    }

    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chartRect.left, chartRect.top),
      Offset(chartRect.left, chartRect.bottom),
      axisPaint,
    );

    const yLabels = ['0', '2', '4', '6', '8'];
    for (int i = 0; i < yLabels.length; i++) {
      final y = chartRect.bottom - (i / 4) * chartRect.height;
      final tp = TextPainter(
        text: TextSpan(
          text: yLabels[i],
          style: const TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(chartRect.left - 10 - tp.width, y - tp.height / 2),
      );
    }

    final xLabels = [
      'dashboard_weekday_mon'.tr,
      'dashboard_weekday_tue'.tr,
      'dashboard_weekday_wed'.tr,
      'dashboard_weekday_thu'.tr,
      'dashboard_weekday_fri'.tr,
      'dashboard_weekday_sat'.tr,
      'dashboard_weekday_sun'.tr,
    ];
    for (int i = 0; i < xLabels.length; i++) {
      final x = chartRect.left + i * (chartRect.width / 6);
      final tp = TextPainter(
        text: TextSpan(
          text: xLabels[i],
          style: const TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, chartRect.bottom + 6));
    }

    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = chartRect.left + i * (chartRect.width / (values.length - 1));
      final y = chartRect.bottom - (values[i] / yMax) * chartRect.height;
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final controlX = (prev.dx + curr.dx) / 2;
      path.cubicTo(controlX, prev.dy, controlX, curr.dy, curr.dx, curr.dy);
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    final markerPaint = Paint()..color = lineColor;
    for (final point in points) {
      canvas.drawCircle(point, 5.5, markerPaint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 3.0;
    final totalLength = (end - start).distance;
    final direction = (end - start) / totalLength;
    double drawn = 0;

    while (drawn < totalLength) {
      final currentStart = start + direction * drawn;
      final currentEnd =
          start + direction * math.min(drawn + dashWidth, totalLength);
      canvas.drawLine(currentStart, currentEnd, paint);
      drawn += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyLineChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

class _SeverityDonutPainter extends CustomPainter {
  const _SeverityDonutPainter({
    required this.low,
    required this.medium,
    required this.high,
  });

  final int low;
  final int medium;
  final int high;

  @override
  void paint(Canvas canvas, Size size) {
    final total = (low + medium + high).toDouble();
    if (total <= 0) {
      return;
    }

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.36;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final values = [low.toDouble(), medium.toDouble(), high.toDouble()];
    const colors = [Color(0xFF10B981), Color(0xFFF59E0B), Color(0xFFEF4444)];
    const gap = 0.08;

    double startAngle = -math.pi;
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * (2 * math.pi);
      final adjustedSweep = math.max(0.0, sweep - gap);

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 26
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, adjustedSweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _SeverityDonutPainter oldDelegate) {
    return oldDelegate.low != low ||
        oldDelegate.medium != medium ||
        oldDelegate.high != high;
  }
}
>>>>>>> master
