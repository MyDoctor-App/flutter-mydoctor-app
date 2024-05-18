import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// screens
import 'package:my_doctor_app/screens/onboarding/onboarding_screen.dart';
import 'package:my_doctor_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyDoctor',
      theme: lightMode,
      home: const IntroScreen(),
      builder: EasyLoading.init(),
    );
  }
}
