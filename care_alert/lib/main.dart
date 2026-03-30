import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:care_alert/core/translations.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceLanguageCode = Get.deviceLocale?.languageCode ?? 'en';

    return GetMaterialApp(
      translations: AppTranslations(),
      locale: Locale(deviceLanguageCode),
      fallbackLocale: const Locale('en'),
      supportedLocales: const [
        Locale('en'),
        Locale('nl'),
        Locale('en', 'US'),
        Locale('nl', 'NL'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: Center(child: Text('hello_world'.tr))),
    );
  }
}
