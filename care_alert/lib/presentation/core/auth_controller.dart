import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  static const String _isLoggedInKey = 'is_logged_in';
  static const String _devModeSkipAuthKey = 'dev_mode_skip_auth';

  final RxBool isLoggedIn = false.obs;
  final RxBool devModeSkipAuth = false.obs;

  final Map<String, Map<String, String>> _demoCredentials = {
    'medewerker': {
      'email': 'medewerker@zorg.nl',
      'password': 'demo123',
    },
    'teamleider': {
      'email': 'teamleider@zorg.nl',
      'password': 'demo123',
    },
    'veiligheid': {
      'email': 'veiligheid@zorg.nl',
      'password': 'demo123',
    },
    'admin': {
      'email': 'admin@zorg.nl',
      'password': 'admin123',
    },
  };

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool(_isLoggedInKey) ?? false;
    devModeSkipAuth.value = prefs.getBool(_devModeSkipAuthKey) ?? false;
  }

  Future<bool> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();

    final matches = _demoCredentials.values.any(
      (c) =>
          c['email'] == normalizedEmail &&
          c['password'] == password,
    );

    isLoggedIn.value = matches;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, matches);

    return matches;
  }

  Future<void> logout() async {
    isLoggedIn.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<void> toggleDevModeSkipAuth() async {
    devModeSkipAuth.value = !devModeSkipAuth.value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_devModeSkipAuthKey, devModeSkipAuth.value);
  }

  Map<String, String> getDemoCredentials(String role) {
    return _demoCredentials[role] ?? const {'email': '', 'password': ''};
  }
}
