import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import 'onboarding_controller.dart';


class onBoardingDotNavigation extends StatelessWidget {
  const onBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<OnBoardingController>();

    return Positioned(
        bottom: TSizes.spaceBottom + 25,
        left: TSizes.defaultSpace,
        child: SmoothPageIndicator(controller: controller.pageController, count: 3, effect: const ExpandingDotsEffect(activeDotColor: TColors.primary,dotHeight: 6,dotColor: TColors.secondary),));
  }
}