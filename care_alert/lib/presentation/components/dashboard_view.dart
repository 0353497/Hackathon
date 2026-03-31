import 'dart:math' as math;

import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
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
                      'Dashboard',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Welkom terug, hier is het overzicht van vandaag',
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
                          label: 'Nieuwe melding',
                          icon: Icons.note_add_outlined,
                          onPressed: () {},
                        ),
                        DashboardActionButton(
                          backgroundColor: const Color(0xFFE10019),
                          label: 'Noodmelding',
                          icon: Icons.warning_amber_rounded,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const DashboardStatsCard(
                      count: 3,
                      title: 'Meldingen vandaag',
                      tagLabel: 'Vandaag',
                      baseColor: Color(0xFF1A66F8),
                      highlightColor: Color(0xFF1A66F8),
                      leadingIcon: Icons.north_east_rounded,
                    ),
                    const SizedBox(height: 14),
                    const DashboardStatsCard(
                      count: 2,
                      title: 'Openstaande meldingen',
                      tagLabel: 'Actief',
                      baseColor: Color(0xFFE5001A),
                      highlightColor: Color(0xFFE5001A),
                      leadingIcon: Icons.watch_later_outlined,
                    ),
                    const SizedBox(height: 14),
                    const DashboardStatsCard(
                      count: 1,
                      title: 'Hoge prioriteit',
                      tagLabel: 'Actief',
                      baseColor: Color(0xFFF56800),
                      highlightColor: Color(0xFFF56800),
                      leadingIcon: Icons.monitor_heart_outlined,
                    ),
                    const SizedBox(height: 14),
                    const DashboardStatsCard(
                      count: 3,
                      title: 'Afgehandeld',
                      tagLabel: 'Voltooid',
                      baseColor: Color(0xFF05B946),
                      highlightColor: Color(0xFF05B946),
                      leadingIcon: Icons.check_circle_outline,
                    ),
                    const SizedBox(height: 20),
                    const DashboardWeeklyTrendCard(),
                    const SizedBox(height: 20),
                    const DashboardSeverityDistributionCard(),
                    const SizedBox(height: 20),
                    const DashboardIncidentTypeCard(),
                    const SizedBox(height: 20),
                    const DashboardRecentAlertsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardTopHeader extends StatelessWidget {
  const DashboardTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1D6BFF), Color(0xFF1145CF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CareAlert',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Meldingen & Incidenten',
                style: TextStyle(
                  color: Color(0xFFD8E5FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardActionButton extends StatelessWidget {
  const DashboardActionButton({
    super.key,
    required this.backgroundColor,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final Color backgroundColor;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        shadowColor: backgroundColor.withValues(alpha: 0.35),
      ),
    );
  }
}

class DashboardStatsCard extends StatelessWidget {
  const DashboardStatsCard({
    super.key,
    required this.count,
    required this.title,
    required this.tagLabel,
    required this.baseColor,
    required this.highlightColor,
    required this.leadingIcon,
  });

  final int count;
  final String title;
  final String tagLabel;
  final Color baseColor;
  final Color highlightColor;
  final IconData leadingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -36,
            top: -44,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: highlightColor.withValues(alpha: 0.52),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(leadingIcon, color: Colors.white),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              const Text(
                'Meldingen deze week',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF001B44),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8E7FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Week',
                      style: TextStyle(
                        color: Color(0xFF1D63F0),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Maand',
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
          const Text(
            'Ontwikkeling van het aantal meldingen',
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
          const Text(
            'Ernst verdeling',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
              color: Color(0xFF001B44),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Verdeling per prioriteit',
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
          const _LegendRow(
            color: Color(0xFF10B981),
            label: 'Laag',
            value: low,
          ),
          const SizedBox(height: 6),
          const _LegendRow(
            color: Color(0xFFF59E0B),
            label: 'Middel',
            value: medium,
          ),
          const SizedBox(height: 6),
          const _LegendRow(
            color: Color(0xFFEF4444),
            label: 'Hoog',
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

class DashboardIncidentTypeCard extends StatelessWidget {
  const DashboardIncidentTypeCard({super.key});

  @override
  Widget build(BuildContext context) {
    const values = [1.0, 1.0, 1.0, 1.0];
    const labels = ['MIC', 'MIM', 'Agressie', 'Ongeval'];

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
          const Text(
            'Meldingen per type',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
              color: Color(0xFF001B44),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Overzicht van alle incidenttypes',
            style: TextStyle(
              color: Color(0xFF49618A),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          AspectRatio(
            aspectRatio: 1.22,
            child: CustomPaint(
              painter: _IncidentTypeBarChartPainter(
                values: values,
                labels: labels,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardRecentAlertsCard extends StatelessWidget {
  const DashboardRecentAlertsCard({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      _RecentAlertItem(
        type: 'MIC',
        status: 'In behandeling',
        statusColor: Color(0xFFE97A18),
        statusBackground: Color(0xFFF7E5CF),
        priority: 'Middel',
        priorityColor: Color(0xFFE97A18),
        priorityBackground: Color(0xFFF7E5CF),
        description: 'Client is gevallen bij het opstaan uit bed. Geen zichtbare verwondingen.',
        dateTime: '30 mrt, 09:15',
        location: 'Afdeling A - Kamer 12',
      ),
      _RecentAlertItem(
        type: 'MIM',
        status: 'Afgehandeld',
        statusColor: Color(0xFF0A9B50),
        statusBackground: Color(0xFFD8F1E3),
        priority: 'Hoog',
        priorityColor: Color(0xFFD12D36),
        priorityBackground: Color(0xFFF7DDE0),
        description: 'Medewerker heeft zich geprikt aan naald tijdens medicijnvoorbereiding.',
        dateTime: '29 mrt, 14:30',
        location: 'Afdeling B - Medicijnkamer',
      ),
      _RecentAlertItem(
        type: 'Brand',
        status: 'Afgehandeld',
        statusColor: Color(0xFF0A9B50),
        statusBackground: Color(0xFFD8F1E3),
        priority: 'Middel',
        priorityColor: Color(0xFFE97A18),
        priorityBackground: Color(0xFFF7E5CF),
        description: 'Brandalarm gegaan vanwege aangebrande pan op het fornuis. Geen brand ontstaan.',
        dateTime: '28 mrt, 11:00',
        location: 'Keuken - Verdieping 2',
      ),
      _RecentAlertItem(
        type: 'Agressie',
        status: 'Open',
        statusColor: Color(0xFFD12D36),
        statusBackground: Color(0xFFF7DDE0),
        priority: 'Laag',
        priorityColor: Color(0xFF0A9B50),
        priorityBackground: Color(0xFFD8F1E3),
        description: 'Client heeft verbaal agressief gedrag vertoond richting medewerker tijdens ochtendroutine.',
        dateTime: '30 mrt, 08:00',
        location: 'Afdeling C - Gemeenschappelijke ruimte',
      ),
    ];

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
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recente meldingen',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF001B44),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Laatste 4 meldingen',
                      style: TextStyle(
                        color: Color(0xFF49618A),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF111827),
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Bekijk alles',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.north_east, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RecentAlertListItem(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentAlertListItem extends StatelessWidget {
  const _RecentAlertListItem({required this.item});

  final _RecentAlertItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip(
                text: item.type,
                textColor: const Color(0xFF1E63F0),
                backgroundColor: const Color(0xFFE8EEF9),
              ),
              _StatusChip(
                text: item.status,
                textColor: item.statusColor,
                backgroundColor: item.statusBackground,
              ),
              _StatusChip(
                text: item.priority,
                textColor: item.priorityColor,
                backgroundColor: item.priorityBackground,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.description,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  'Details',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF6B7280)),
              Text(
                item.dateTime,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text('•', style: TextStyle(color: Color(0xFF6B7280))),
              const Icon(Icons.person_outline, size: 14, color: Color(0xFF6B7280)),
              Text(
                item.location,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.text,
    required this.textColor,
    required this.backgroundColor,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RecentAlertItem {
  const _RecentAlertItem({
    required this.type,
    required this.status,
    required this.statusColor,
    required this.statusBackground,
    required this.priority,
    required this.priorityColor,
    required this.priorityBackground,
    required this.description,
    required this.dateTime,
    required this.location,
  });

  final String type;
  final String status;
  final Color statusColor;
  final Color statusBackground;
  final String priority;
  final Color priorityColor;
  final Color priorityBackground;
  final String description;
  final String dateTime;
  final String location;
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
      tp.paint(canvas, Offset(chartRect.left - 10 - tp.width, y - tp.height / 2));
    }

    const xLabels = ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'];
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

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
  ) {
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

class _IncidentTypeBarChartPainter extends CustomPainter {
  const _IncidentTypeBarChartPainter({
    required this.values,
    required this.labels,
  });

  final List<double> values;
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    const axisColor = Color(0xFF94A3B8);
    const gridColor = Color(0xFFD7DCE4);
    const barColor = Color(0xFF5B8FE8);
    const yLabels = ['0', '0.25', '0.5', '0.75', '1'];

    final chartRect = Rect.fromLTRB(54, 12, size.width - 12, size.height - 32);

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

    for (int i = 0; i < values.length; i++) {
      final x = chartRect.left + i * (chartRect.width / values.length);
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
      tp.paint(canvas, Offset(chartRect.left - 10 - tp.width, y - tp.height / 2));
    }

    final barSpace = chartRect.width / values.length;
    final barWidth = barSpace * 0.72;
    final barPaint = Paint()..color = barColor.withValues(alpha: 0.92);

    for (int i = 0; i < values.length; i++) {
      final barHeight = values[i].clamp(0.0, 1.0) * chartRect.height;
      final left = chartRect.left + i * barSpace + (barSpace - barWidth) / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, chartRect.bottom - barHeight, barWidth, barHeight),
        const Radius.circular(8),
      );
      canvas.drawRRect(rect, barPaint);
    }

    for (int i = 0; i < labels.length; i++) {
      if (labels[i].isEmpty) {
        continue;
      }
      final x = chartRect.left + i * barSpace + (barSpace / 2);
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
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
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
  ) {
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
  bool shouldRepaint(covariant _IncidentTypeBarChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.labels != labels;
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
