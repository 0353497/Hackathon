import 'package:care_alert/presentation/components/tab_page.dart';
import 'package:care_alert/presentation/pages/alerts_page.dart';
import 'package:care_alert/presentation/pages/create_alert_page.dart';
import 'package:care_alert/presentation/pages/dashboard.dart';
import 'package:care_alert/presentation/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const Dashboard(),
    const CreateAlertPage(),
    const AlertsPage(),
    const TabPage(
      titleKey: 'notificaties_page_title',
      icon: Icons.notifications_active_outlined,
    ),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: 'dashboard'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_alert_outlined),
            selectedIcon: const Icon(Icons.add_alert),
            label: 'new_melding'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.warning_amber_outlined),
            selectedIcon: const Icon(Icons.warning_amber),
            label: 'meldingen'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.notifications_none_outlined),
            selectedIcon: const Icon(Icons.notifications),
            label: 'notificaties'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: 'Settings'.tr,
          ),
        ],
      ),
    );
  }
}
