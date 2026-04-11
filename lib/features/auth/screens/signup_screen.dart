import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // نحتاجها للتحكم في مدخلات الأرقام فقط
// تأكد من استيراد صفحة اللوجن بشكل صحيح
import 'package:my_sweing_app/features/auth/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // متغير للتحكم في ظهور كلمة السر
  bool _isPasswordObscured = true;

  // التحكم في رقم الهاتف ببادئة ثابتة
  final TextEditingController _phoneController = TextEditingController(
    text: '+962 ',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. صورة الفتاة في الأعلى
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Image.asset(
              'assets/images/SignGirl.png',
              fit: BoxFit.contain,
            ),
          ),

          // 2. الحاوية الزرقاء والمحتويات
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFDDE3FE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Sign Up , NOW',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'please login to continue using the app',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    // حقول الإدخال العادية
                    _buildTextField(hint: 'Full Name'),
                    const SizedBox(height: 15),
                    _buildTextField(hint: 'Email'),
                    const SizedBox(height: 15),

                    // حقل كلمة السر مع العين التفاعلية
                    _buildPasswordField(),
                    const SizedBox(height: 15),

                    // حقل رقم الهاتف المطور
                    _buildPhoneField(),

                    const SizedBox(height: 40),

                    // زر التسجيل
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // أضف وظيفة التسجيل هنا
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD573),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // رابط الانتقال لصفحة تسجيل الدخول
                    _buildLoginLink(context),

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

  // دالة بناء الحقول العادية
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
          borderSide: BorderSide.none,
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
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey,
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

  // دالة بناء حقل رقم الهاتف (أرقام فقط + كود ثابت)
  Widget _buildPhoneField() {
    return TextField(
      controller: _phoneController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9+]'),
        ), // يسمح بالأرقام وعلامة + فقط
      ],
      onChanged: (value) {
        // منع المستخدم من حذف كود الدولة
        if (!value.startsWith('+962 ')) {
          _phoneController.text = '+962 ';
          _phoneController.selection = TextSelection.fromPosition(
            TextPosition(offset: _phoneController.text.length),
          );
        }
        // التأكد من أن الطول الإجمالي لا يتجاوز الكود + 9 أرقام
        if (value.length > 14) {
          _phoneController.text = value.substring(0, 14);
          _phoneController.selection = TextSelection.fromPosition(
            TextPosition(offset: _phoneController.text.length),
          );
        }
      },
      decoration: InputDecoration(
        hintText: 'Phone Number',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // دالة بناء رابط تسجيل الدخول
  Widget _buildLoginLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black54, fontSize: 14),
          children: [
            const TextSpan(text: "Already got an account, "),
            TextSpan(
              text: "LOG IN now !!",
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
