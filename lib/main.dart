import 'package:flutter/material.dart';
import 'package:my_sweing_app/core/app_theme.dart';
import 'package:my_sweing_app/features/main_wrapper/main_wrapper.dart';
import 'package:my_sweing_app/features/shop/screens/welcome_screen.dart';

void main() {
  runApp(const WarradApp());
}

class WarradApp extends StatelessWidget {
  const WarradApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warrad Fashion',
      theme: AppTheme.lightTheme,
      // إذا كنتِ تريدين الدخول مباشرة للنظام:
      home: const MainWrapper(),
      // أو إذا أردتِ البدء بصفحة الترحيب ثم الانتقال:
      // home: const WelcomeScreen(),
    );
  }
}
