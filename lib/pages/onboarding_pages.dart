//import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
//import 'package:new_project/buttons/glowing_button.dart';
import 'package:new_project/buttons/glowing_button.dart';
import 'package:new_project/intro_screens/First_Page.dart';
import 'package:new_project/intro_screens/Sec_Page.dart';
import 'package:new_project/intro_screens/third_page.dart';
import 'package:new_project/pages/home_page.dart';

Color bgcolor = Colors.black54;

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  void changePage() {
    // Navigate to the next page or any other action
    if (onLastPage) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  onLastPage =
                      (index == 2); // Update to match your total page count
                });
              },
              children: [
                Container(
                  color: bgcolor,
                  child: Center(child: IntroPage1()),
                ),
                Container(
                  color: bgcolor,
                  child: Center(child: IntroPage2()),
                ),
                Container(
                  color: bgcolor,
                  child: Center(child: IntroPage3()),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment(0, 0.85),
            padding: const EdgeInsets.only(bottom: 20),
            child: GlowingButton(
              onPressed: changePage,
              text: 'Next',
            ),
          ),
        ],
      ),
    );
  }
}
