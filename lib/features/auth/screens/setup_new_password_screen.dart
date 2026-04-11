import 'package:flutter/material.dart';
import 'package:my_sweing_app/features/shop/screens/ready_screen.dart';

class SetupNewPasswordScreen extends StatelessWidget {
  const SetupNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على أبعاد الشاشة لجعل المساحات متجاوبة
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // الحل الأساسي: استخدام SingleChildScrollView لمنع خطأ الـ Overflow
        child: SingleChildScrollView(
          // BouncingScrollPhysics تعطي شعوراً أفضل عند التمرير في iOS و Android
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ConstrainedBox(
            // نحدد ارتفاع أدنى للحاوية ليساوي طول الشاشة (ناقص مساحة الـ SafeArea)
            constraints: BoxConstraints(
              minHeight:
                  screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // 1. الصورة التوضيحية
                  SizedBox(
                    height: screenHeight * 0.25,
                    child: Image.asset(
                      'assets/images/setup_password_illustration.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 2. النصوص العنوانية
                  const Text(
                    'Setup New Password',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Please, setup a new password for\nyour account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 3. حقول إدخال كلمة السر
                  _buildPasswordField(hint: 'New Password'),
                  const SizedBox(height: 15),
                  _buildPasswordField(hint: 'Repeat Password'),

                  // نستخدم Spacer داخل IntrinsicHeight ليدفع الأزرار للأسفل
                  const Spacer(),

                  const SizedBox(height: 20),

                  // 4. زر Save
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // الانتقال لصفحة "Ready" ومسح جميع الصفحات السابقة من الـ Stack
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReadyScreen(),
                          ),
                          (route) =>
                              false, // هذا السطر يمنع العودة للخلف لصفحات إعداد كلمة السر
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
                        'Save',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ), 
                  const SizedBox(height: 10),

                  // 5. زر Cancel
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 30), // مساحة إضافية في الأسفل
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({required String hint}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDDE3FE),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF5C5C5C),
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
        ),
      ),
    );
  }
}
