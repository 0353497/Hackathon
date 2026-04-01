import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  final RxBool isLoggedIn = false.obs;
  final RxBool devModeSkipAuth = false.obs;

  void login() {
    isLoggedIn.value = true;
  }

  void logout() {
    isLoggedIn.value = false;
  }

  void toggleDevModeSkipAuth() {
    devModeSkipAuth.value = !devModeSkipAuth.value;
  }
}
