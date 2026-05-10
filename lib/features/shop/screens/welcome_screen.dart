import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_sweing_app/features/main_wrapper/main_wrapper.dart';
import 'package:my_sweing_app/features/shop/screens/home_screen.dart';

void main() {
  runApp(const WarradFashionApp());
}

class WarradFashionApp extends StatelessWidget {
  const WarradFashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
void initState() {
  super.initState();
  // التعديل هنا: ننتقل إلى MainWrapper وليس HomeScreen مباشرة
  Timer(const Duration(seconds: 3), () {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          // وجهة الانتقال هي MainWrapper الذي يحتوي على الـ Bottom Nav Bar
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainWrapper(), 
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEF),
      body: Stack(
        children: [
          // Animated background particles
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation:
                  ModalRoute.of(context)?.animation ??
                  AlwaysStoppedAnimation(0),
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.5, -0.5),
                      radius: 1.5,
                      colors: [
                        const Color(0xFFDDE3FE).withOpacity(0.3),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Main logo animation
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo with pulse effect
                AnimatedBuilder(
                  animation:
                      ModalRoute.of(context)?.animation ??
                      AlwaysStoppedAnimation(0),
                  builder: (context, child) {
                    return Transform.scale(
                      scale:
                          1.0 +
                          (0.1 *
                              (ModalRoute.of(context)?.animation?.value ?? 0)),
                      child: Container(
                        height: 280,
                        width: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFDDE3FE).withOpacity(0.6),
                              blurRadius: 60,
                              spreadRadius: 15,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/Untitled.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Brand name with staggered animation
                const Text(
                  'WARRAD',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                    letterSpacing: 5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'FASHION',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3E2723),
                    letterSpacing: 10,
                  ),
                ),

                const Spacer(flex: 2),

                // Progress indicator + Timer
                Column(
                  children: [
                    // Loading dots animation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: index == 0
                                ? const Color(0xFFDDE3FE)
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
