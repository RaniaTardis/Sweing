import 'package:flutter/material.dart';
import 'package:my_sweing_app/features/auth/screens/setup_new_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  // للتحكم في نص الكود
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. الدوائر في الزاوية العلوية اليمنى (كما في الصورة)
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
                    'Enter 4-digits code we sent you\non your email address',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // الإيميل المقنع (Masked Email) كما في طلبك
                  const Text(
                    'wa****d@email.com', // مثال للإيميل المقنع
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // مربعات إدخال الكود (OTP Inputs)
                  // قمت بتبسيطها باستخدام TextField واحد بتنسيق خاص
                  Container(
                    width: 280,
                    child: TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 4, // طول الكود 4 أرقام
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing:
                            35, // مسافة كبيرة بين الأرقام لتبدو كمربعات
                      ),
                      decoration: InputDecoration(
                        counterText: "", // إخفاء عداد الحروف
                        filled: true,
                        fillColor: const Color(
                          0xFFDDE3FE,
                        ), // لون المربعات الأزرق اللافندر
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // زر Done
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // الانتقال لصفحة تعيين كلمة المرور الجديدة
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SetupNewPasswordScreen(),
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
                        'Done',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // زر Send again
                  TextButton(
                    onPressed: () {
                      // وظيفة إعادة إرسال الكود
                    },
                    child: const Text(
                      'send again',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),

                  // زر Cancel
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
