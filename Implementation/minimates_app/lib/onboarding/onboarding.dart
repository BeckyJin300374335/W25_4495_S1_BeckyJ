import 'dart:developer';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/auth/auth_page.dart';
import 'package:untitled1/onboarding/onboarding_controller.dart';
import 'package:untitled1/screens/home.dart';
import 'package:untitled1/utils/constants/sizes.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/image_strings.dart';
import '../utils/constants/text_strings.dart';
import 'onboarding_dot_navigation.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());


    return  Scaffold(
      body: Stack(
        children: [
          /// horizontal scrollable pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              onBoardingPage(title: TTexts.onBoardingTitle1, subTitle: TTexts.onBoardingSubTitle1, image: TImages.onBoardingImage1),
              onBoardingPage(title: TTexts.onBoardingTitle2, subTitle: TTexts.onBoardingSubTitle2, image: TImages.onBoardingImage2),
              onBoardingPage(title: TTexts.onBoardingTitle3, subTitle: TTexts.onBoardingSubTitle3, image: TImages.onBoardingImage3),

            ],
          ),
          /// skip button
          Positioned(
              top: TSizes.appBarHeight,
              right: TSizes.defaultSpace,
              child: TextButton(onPressed: (){
                OnBoardingController.instance.nextPage();
              }, child: const Text(
                'Skip',
                style: TextStyle(
                fontSize: 20,          // Set the desired font size (adjust as needed)
                color: TColors.secondary,      // Set the desired text color
              ),)),
          ),
          /// dot navigation indicator
          onBoardingDotNavigation(),
          
          /// circular button
          Positioned(
              right: TSizes.defaultSpace,
              bottom: TSizes.spaceBottom,
              child: ElevatedButton(
                  onPressed: (){
                    controller.nextPage();
                    if (controller.currentPageIndex.value == 2) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => Auth_Page(),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(shape: const CircleBorder(
                    side: BorderSide(
                      color: TColors.secondary, // Set the border color to accent
                      width: 0,            // Adjust the width as needed
                    ),
                  ), backgroundColor: TColors.secondary),
                  child: const Text('Next')))

        ],

      ),
    );
  }
}



class onBoardingPage extends StatelessWidget {
  const onBoardingPage({
    super.key, required this.title, required this.subTitle, required this.image,
  });

  final String title, subTitle, image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.spaceBottom),
      child: Column(
        children: [
          Image(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            image: AssetImage(image),
          ),
          SizedBox(height:TSizes.spaceBtwSections),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height:TSizes.spaceBtwItems),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],

      ),
    );
  }
}

