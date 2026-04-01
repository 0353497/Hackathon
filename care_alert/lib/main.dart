import 'package:care_alert/core/app_theme.dart';
import 'package:care_alert/presentation/pages/main_view.dart';
import 'package:care_alert/presentation/core/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:care_alert/core/translations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Locale _resolveLocale(Locale? deviceLocale) {
    if (deviceLocale == null) {
      return const Locale('en');
    }

    const supported = [
      Locale('en'),
      Locale('nl'),
      Locale('en', 'US'),
      Locale('nl', 'NL'),
    ];

    for (final locale in supported) {
      if (locale.languageCode == deviceLocale.languageCode &&
          locale.countryCode == deviceLocale.countryCode) {
        return locale;
      }
    }

    for (final locale in supported) {
      if (locale.languageCode == deviceLocale.languageCode) {
        return locale;
      }
    }

    return const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    final resolvedLocale = _resolveLocale(Get.deviceLocale);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GetMaterialApp(
      translations: AppTranslations(),
      locale: resolvedLocale,
      fallbackLocale: const Locale('en'),
      theme: AppTheme.lightTheme,
      supportedLocales: const [
        Locale('en'),
        Locale('nl'),
        Locale('en', 'US'),
        Locale('nl', 'NL'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        return _resolveLocale(locale);
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home: const MainView(),
    );
  }
}
