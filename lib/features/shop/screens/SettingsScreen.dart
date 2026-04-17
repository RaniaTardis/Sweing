import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // خلفية فاتحة جداً لتعزيز المظهر العصري
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم المعلومات الشخصية (Personal)
            _buildSectionTitle("Personal"),
            _buildSettingsGroup([
              _buildSettingsTile(Icons.person_outline, "Profile", () {}),
              _buildSettingsTile(
                Icons.location_on_outlined,
                "Shipping Address",
                () {},
              ),
              _buildSettingsTile(
                Icons.payment_outlined,
                "Payment methods",
                () {},
              ),
            ]),

            const SizedBox(height: 25),

            // قسم المتجر (Shop)
            _buildSectionTitle("Shop"),
            _buildSettingsGroup([
              _buildSettingsTile(Icons.public, "Country", () {}),
              _buildSettingsTile(
                Icons.monetization_on_outlined,
                "Currency",
                () {},
                trailingText: "USD",
              ),
            ]),

            const SizedBox(height: 25),

            // قسم المعلومات القانونية
            _buildSettingsGroup([
              _buildSettingsTile(
                Icons.description_outlined,
                "Terms and Conditions",
                () {},
              ),
            ]),

            const SizedBox(height: 25),

            // قسم الحساب (Account)
            _buildSectionTitle("Account"),
            _buildSettingsGroup([
              _buildSettingsTile(
                Icons.language,
                "Language",
                () {},
                trailingText: "English",
              ),
              _buildSettingsTile(Icons.info_outline, "About Slada", () {}),
            ]),

            const SizedBox(height: 30),

            // زر حذف الحساب
            Center(
              child: TextButton(
                onPressed: () {
                  // هنا نضع منطق حذف الحساب
                },
                child: const Text(
                  "Delete My Account",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // تذييل الصفحة (Footer)
            Center(
              child: Column(
                children: [
                  const Text(
                    "Slada",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Version 1.0 April, 2026",
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // بناء عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // بناء مجموعة من الخيارات داخل حاوية واحدة بظلال
  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // بناء خيار إعداد واحد (Tile)
  Widget _buildSettingsTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? trailingText,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blueAccent, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          const SizedBox(width: 5),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        ],
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
