import 'package:care_alert/core/app_theme.dart';
import 'package:care_alert/domain/utils/biometric_auth_service.dart';
import 'package:care_alert/presentation/pages/main_view.dart';
import 'package:care_alert/presentation/pages/login_page.dart';
import 'package:care_alert/presentation/core/auth_controller.dart';
import 'package:care_alert/presentation/core/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:care_alert/core/translations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  Get.put(AuthController());

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
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (AuthController.to.devModeSkipAuth.value ||
          AuthController.to.isLoggedIn.value) {
        return const AppLockGate();
      }

      return const LoginPage();
    });
  }
}

class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key});

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> {
  final BiometricAuthService _biometricAuthService = BiometricAuthService();

  bool _isChecking = true;
  bool _isUnlocked = false;
  String _message = 'Beveiliging controleren...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _unlockApp();
    });
  }

  Future<void> _unlockApp() async {
    setState(() {
      _isChecking = true;
      _message = 'Beveiliging controleren...';
    });

    final available = await _biometricAuthService.isBiometricAvailable();

    if (!mounted) {
      return;
    }

    if (!available) {
      setState(() {
        _isChecking = false;
        _isUnlocked = false;
        _message = 'Geen Face ID of vingerafdruk beschikbaar op dit toestel';
      });
      return;
    }

    final authenticated = await _biometricAuthService.authenticateForUnlock();

    if (!mounted) {
      return;
    }

    setState(() {
      _isChecking = false;
      _isUnlocked = authenticated;
      _message = authenticated
          ? ''
          : 'Ontgrendelen mislukt of geannuleerd. Probeer opnieuw.';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isUnlocked) {
      return const MainView();
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint, size: 64),
              const SizedBox(height: 16),
              const Text(
                'App vergrendeld',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (_isChecking)
                const CircularProgressIndicator()
              else
                Text(
                  _message,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              if (!_isChecking)
                ElevatedButton.icon(
                  onPressed: _unlockApp,
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Ontgrendel met biometrie'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
