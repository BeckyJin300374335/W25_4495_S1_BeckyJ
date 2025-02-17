import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:untitled1/auth/auth_page.dart';

import '../screens/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance =>
      Get.find(); //access an instance of OnboardingController

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs; // observer

//index of the currently active page

  void updatePageIndicator(index) =>
      currentPageIndex.value = index; //update index when page scroll

  void dotNavigationClick(index) {
    pageController.jumpTo(index);
    currentPageIndex.value = index;
  } //jump to specific page

  void nextPage() {
    if (currentPageIndex.value == 2) {
      // Get.to(LoginPage());)
      Get.off(() => Auth_Page());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  } //update current index & jump to next page

  void skipPage() {
    // pageController.jumpToPage(2);
    // currentPageIndex.value = 2;
    Get.off(() => Auth_Page());
  } //update current index & jump to next page
}
