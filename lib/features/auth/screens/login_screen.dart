import 'package:flutter/material.dart';
import 'dart:convert'; // لتحويل البيانات إلى JSON
import 'package:http/http.dart'
    as http; // للمطالبة بإضافة المكتبة في pubspec.yaml
import 'package:my_sweing_app/features/auth/screens/password_recovery_screen.dart';
import 'package:my_sweing_app/features/auth/screens/signup_screen.dart';
import 'package:my_sweing_app/features/main_wrapper/main_wrapper.dart';
import 'package:my_sweing_app/features/shop/screens/home_screen.dart';
import 'package:my_sweing_app/features/shop/screens/product_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. تعريف المتحكمات لاستخراج النص من الحقول
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isLoading = false; // لمتابعة حالة الاتصال بالسيرفر

  // 2. دالة تسجيل الدخول والاتصال بـ Node.js
  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('http://localhost:3000/auth/login');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ حفظ userId في SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', data['user']['id']);
        await prefs.setString('userToken', data['token']);
        await prefs.setString('userEmail', data['user']['email']);
        await prefs.setString('userName', data['user']['name']);

        print('✅ User ID saved: ${data['user']['id']}');

        // الانتقال إلى MainWrapper
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not connect to server')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Image.asset(
              'assets/images/SignGirl.png',
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.68,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFDDE3FE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                border: Border(
                  top: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Log in Now',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'please login to continue using the app',
                      style: TextStyle(color: Colors.black87, fontSize: 15),
                    ),
                    const SizedBox(height: 40),

                    // حقل الإيميل
                    _buildTextField(
                      hint: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // حقل الباسورد
                    _buildPasswordField(),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PasswordRecoveryScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'forgot Password?',
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // زر تسجيل الدخول مع حالة التحميل
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD573),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          elevation: 0,
                          side: const BorderSide(color: Colors.black12),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : const Text(
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

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
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

  Widget _buildSignupLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupScreen()),
        );
      },
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: "Sign up now !!",
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
