import 'package:flutter/material.dart';
import 'package:my_sweing_app/features/shop/screens/ready_screen.dart';

class SetupNewPasswordScreen extends StatelessWidget {
  const SetupNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
  
        child: SingleChildScrollView(
  
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ConstrainedBox(
          
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

                 
                  SizedBox(
                    height: screenHeight * 0.25,
                    child: Image.asset(
                      'assets/images/setup_password_illustration.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 30),

                 
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

         
                  _buildPasswordField(hint: 'New Password'),
                  const SizedBox(height: 15),
                  _buildPasswordField(hint: 'Repeat Password'),

            
                  const Spacer(),

                  const SizedBox(height: 20),

                
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                       
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReadyScreen(),
                          ),
                          (route) =>
                              false, 
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
