import 'package:flutter/material.dart';
import 'package:my_sweing_app/features/shop/screens/home_screen.dart';

class ReadyScreen extends StatelessWidget {
  const ReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الحاوية الرئيسية التي تشبه الكرت الأبيض في الصورة
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 1. الجزء العلوي: الصورة
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                      child: Image.asset(
                        'assets/images/shopping_girls.png', // تأكد من إضافة صورتك هنا
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 2. النص الرئيسي
                    const Text(
                      'Ready?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 3. النص الفرعي
                    const Text(
                      'shope and do all you want',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 4. زر Let's Start
                 Padding(
  padding: const EdgeInsets.symmetric(horizontal: 40),
  child: SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: () {
        // الانتقال لصفحة الهوم (HomeScreen) 
        // نستخدم pushReplacement لكي لا يتمكن المستخدم من العودة لصفحة البداية عند الضغط على زر الرجوع
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDDE3FE), // اللون الأزرق الفاتح
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Text(
        "Let's Start",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ),
),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 5. مؤشر الصفحات (Dots Indicator)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: true), // النقطة الأخيرة هي النشطة كما في الصورة
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت لبناء النقاط السفلية
  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey : const Color(0xFFDDE3FE),
        shape: BoxShape.circle,
      ),
    );
  }
}