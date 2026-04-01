import 'package:flutter/material.dart';
import 'package:care_alert/presentation/components/layout.dart';
import 'package:get/get.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutPage(child: DashboardContent());
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
    Navigator.pushNamed(
      context,
      '/nieuwe-melding',
      arguments: {'category': category},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          // Header
          Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'dashboard_welcome'.tr,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'dashboard_question'.tr,
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'textHint'.tr,
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
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
                          child: Icon(
                            type['icon'],
                            color: type['iconColor'],
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          (type['titleKey'] as String).tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          (type['subtitleKey'] as String).tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          (type['descriptionKey'] as String).tr,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('💡', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'dashboard_how_it_works'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text('dashboard_step_1'.tr),
                        Text('dashboard_step_2'.tr),
                        Text('dashboard_step_3'.tr),
                        Text('dashboard_step_4'.tr),
                        const SizedBox(height: 8),
                        Text(
                          'dashboard_auto_info'.tr,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
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
