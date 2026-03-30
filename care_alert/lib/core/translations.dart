import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {'hello_world': 'Hello World!'},
    'en_US': {'hello_world': 'Hello World!'},
    'nl': {'hello_world': 'Hallo wereld!'},
    'nl_NL': {'hello_world': 'Hallo wereld!'},
  };
}
