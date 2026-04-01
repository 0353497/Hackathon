import 'package:flutter/material.dart';
import 'package:care_alert/presentation/components/settings_component.dart';
import 'package:care_alert/presentation/components/layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LayoutPage(
      child: SettingsComponent(),
    );
  }
}