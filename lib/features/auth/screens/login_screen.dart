import 'package:flutter/material.dart';
import 'package:my_sweing_app/features/auth/screens/password_recovery_screen.dart';
import 'package:my_sweing_app/features/auth/screens/signup_screen.dart'; // استيراد صفحة التسجيل

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // متغير للتحكم في ظهور كلمة السر
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // الجزء العلوي أبيض
      body: Stack(
        children: [
          // 1. صورة الفتاة في أعلى الصفحة
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Image.asset(
              'assets/images/LoginGirl.png', // تأكد من اسم الصورة لديك
              fit: BoxFit.contain,
            ),
          ),

          // 2. الجزء الأزرق (الخلفية المنحنية) والمحتوى
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.68,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFDDE3FE), // اللون الأزرق اللافندر
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                // إضافة حدود سوداء خفيفة كما في الصورة
                border: Border(
                  top: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // العنوان الرئيسي
                    const Text(
                      'Log in Now',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'please login to countinue using the app',
                      style: TextStyle(color: Colors.black87, fontSize: 15),
                    ),
                    const SizedBox(height: 40),

                    // حقل البريد الإلكتروني
                    _buildTextField(hint: 'Email'),
                    const SizedBox(height: 20),

                    // حقل كلمة السر مع العين التفاعلية
                    _buildPasswordField(),

                    // رابط نسيت كلمة السر
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          // الانتقال لصفحة استعادة كلمة المرور
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PasswordRecoveryScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'forgot , Password?',
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // زر الدخول (Log in)
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // وظيفة تسجيل الدخول
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFFFD573,
                          ), // اللون الأصفر
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          elevation: 0,
                          side: const BorderSide(color: Colors.black12),
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // رابط "ليس لدي حساب" للذهاب لصفحة التسجيل
                    _buildSignupLink(context),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة بناء حقل الإدخال العادي
  Widget _buildTextField({required String hint}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }

  // دالة بناء حقل كلمة السر مع التحكم بالعين
  Widget _buildPasswordField() {
    return TextField(
      obscureText: _isPasswordObscured,
      decoration: InputDecoration(
        hintText: 'Password',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
        ),
      ),
    );
  }

  // دالة بناء رابط الانتقال لصفحة التسجيل
  Widget _buildSignupLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // الانتقال لصفحة SignupScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupScreen()),
        );
      },
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: "does not have an account , "),
            TextSpan(
              text: "sign in now !!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
