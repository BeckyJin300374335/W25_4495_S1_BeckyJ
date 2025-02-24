import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:untitled1/auth/auth_page.dart';

import '../screens/login.dart';

class OnBoardingController extends GetMaterialController {
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
    if (currentPageIndex.value < 2) {  // ✅ Ensure only 3 pages exist
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAll(() => Auth_Page()); // ✅ Ensure full reset to Auth Page
    }
  } //update current index & jump to next page

  void skipPage() {
    pageController.jumpToPage(2);
    currentPageIndex.value = 2;

  } //update current index & jump to next page
}
