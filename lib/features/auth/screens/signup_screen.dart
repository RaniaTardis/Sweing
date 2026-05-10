import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_sweing_app/core/app_localizations.dart';
import 'package:my_sweing_app/features/auth/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordObscured = true;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(
    text: '+962 ',
  );

  Future<void> _signUp() async {
    final loc = AppLocalizations.of(context);

    const String url = "http://localhost:3000/auth/signup";

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.t('please_fill_all'))));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text,
          "phone": _phoneController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.t('account_created'))),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        final errorData = jsonDecode(response.body);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'] ?? "Signup failed")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.t('connect_error'))),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                    Text(
                      loc.t('sign_up_now_title'),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      loc.t('signup_subtitle'),
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    _buildTextField(
                      hint: loc.t('full_name'),
                      controller: _nameController,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      hint: loc.t('email'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _buildPasswordField(),
                    const SizedBox(height: 15),
                    _buildPhoneField(),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD573),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Text(
                                loc.t('sign_up'),
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
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

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
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
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    final loc = AppLocalizations.of(context);
    return TextField(
      controller: _passwordController,
      obscureText: _isPasswordObscured,
      decoration: InputDecoration(
        hintText: loc.t('password'),
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
          onPressed: () =>
              setState(() => _isPasswordObscured = !_isPasswordObscured),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    final loc = AppLocalizations.of(context);
    return TextField(
      controller: _phoneController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s]')),
      ],
      onChanged: (value) {
        if (!value.startsWith('+962 ')) {
          _phoneController.value = TextEditingValue(
            text: '+962 ',
            selection: const TextSelection.collapsed(offset: 5),
          );
        }
      },
      decoration: InputDecoration(
        hintText: loc.t('phone_number'),
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

  Widget _buildLoginLink(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black54, fontSize: 14),
          children: [
            TextSpan(text: loc.t('have_account')),
            TextSpan(
              text: loc.t('log_in_now_link'),
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
