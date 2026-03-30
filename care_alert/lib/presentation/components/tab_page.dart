import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class TabPage extends StatelessWidget {
  final String titleKey;
  final IconData icon;

  const TabPage({required this.titleKey, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56),
          const SizedBox(height: 12),
          Text(titleKey.tr, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}
