import 'package:flutter/material.dart';
import 'package:my_sweing_app/features/auth/screens/signup_screen.dart';
import 'package:my_sweing_app/features/auth/screens/login_screen.dart'; // تأكد من استيراد صفحة اللوجن

void main() {
  runApp(const WarradFashionApp());
}

class WarradFashionApp extends StatelessWidget {
  const WarradFashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEF),
      body: Stack(
        children: [
          // الدوائر في الخلفية
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: 180,
              height: 220,
              child: OverflowBox(
                maxWidth: 400,
                maxHeight: 400,
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: const Offset(-80, -80),
                  // child: Image.asset(
                  //   'assets/images/Untitled.png',
                  //   fit: BoxFit.contain,
                  // ),
                ),
              ),
            ),
          ),

          // المحتوى الرئيسي
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),

                    // اللوقو الضخم
                    Transform.scale(
                      scale: 1.5,
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFDDE3FE).withOpacity(0.4),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/Untitled.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // اسم البراند
                    const Text(
                      'WARRAD',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                        letterSpacing: 4,
                      ),
                    ),
                    const Text(
                      'FASHION',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: 8,
                      ),
                    ),

                    const Spacer(flex: 2),

                    // زر Let's get started -> يذهب لـ Signup
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDDE3FE),
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Let's get started",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // رابط I already have an account -> يذهب لـ Login
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "I already have an account",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDDE3FE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward, size: 20),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ], // إغلاق قائمة أطفال العمود (Column children)
                ), // إغلاق العمود (Column)
              ), // إغلاق الحاشية (Padding)
            ), // إغلاق المركز (Center)
          ), // إغلاق منطقة الأمان (SafeArea)
        ], // إغلاق قائمة أطفال الـ Stack
      ), // إغلاق الـ Stack
    ); // إغلاق الـ Scaffold
  } // إغلاق بناء الويدجت (build method)
} // إغلاق الكلاس (WelcomeScreen class)
