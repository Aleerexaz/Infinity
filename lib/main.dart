import 'package:flutter/material.dart';

import 'pages/onboarding_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Pref.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
    );
  }
}
