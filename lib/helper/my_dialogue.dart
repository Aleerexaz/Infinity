import 'package:get/get.dart';

class MyDialogue {
  static void info(String msg, String title) {
    Get.snackbar(title, msg);
  }
}
