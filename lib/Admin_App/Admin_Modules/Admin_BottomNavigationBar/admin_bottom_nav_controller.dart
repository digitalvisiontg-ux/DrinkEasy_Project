import 'package:get/get.dart';

class AdminBottomNavController extends GetxController {
  var index = 0.obs;

  void changeTab(int i) {
    index.value = i;
  }
}
