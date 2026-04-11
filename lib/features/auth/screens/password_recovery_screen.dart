import 'package:flutter/material.dart';
import 'package:my_sweing_app/features/auth/screens/verify_code_screen.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. الدوائر في الزاوية العلوية اليمنى
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 250,
              height: 250,
              child: OverflowBox(
                maxWidth: 500,
                maxHeight: 500,
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: const Offset(80, -80),
                  child: Image.asset(
                    'assets/images/Untitled.png', // تأكد من وجود ملف الدوائر
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // 2. المحتوى الرئيسي
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // العنوان
                  const Text(
                    'Password Recovery',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'How you would like to restore\nyour password?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // خيار الـ Email فقط (كما طلبت)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD573), // اللون الأصفر المشمشي
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black12, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5C5C5C),
                          ),
                        ),
                        const Spacer(),
                        // أيقونة الاختيار (مفعلة دائماً لأنه الخيار الوحيد)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // زر Next
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // الانتقال لصفحة إدخال كود التحقق (OTP)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VerifyCodeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDDE3FE),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // زر Cancel للعودة للخلف
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
