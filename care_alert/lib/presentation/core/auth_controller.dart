import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

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

  Future<bool> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();

    final matches = _demoCredentials.values.any(
      (c) =>
          c['email'] == normalizedEmail &&
          c['password'] == password,
    );

    isLoggedIn.value = matches;
    return matches;
  }

  void logout() {
    isLoggedIn.value = false;
  }

  void toggleDevModeSkipAuth() {
    devModeSkipAuth.value = !devModeSkipAuth.value;
  }

  Map<String, String> getDemoCredentials(String role) {
    return _demoCredentials[role] ?? const {'email': '', 'password': ''};
  }
}
