import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final int? userId; // أضفنا الـ userId هنا
  const SettingsScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = userId != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
        // centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoggedIn) ...[
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
            ],
            _buildSectionTitle("Shop"),
            _buildSettingsGroup([
              _buildSettingsTile(Icons.public, "Country", () {}),
              _buildSettingsTile(
                Icons.monetization_on_outlined,
                "Currency",
                () {},
                trailingText: "JOD",
              ),
            ]),
            const SizedBox(height: 25),

            _buildSectionTitle("Account"),
            _buildSettingsGroup([
              _buildSettingsTile(
                Icons.language,
                "Language",
                () {},
                trailingText: "English",
              ),
              _buildSettingsTile(
                Icons.info_outline,
                "About Warrad",
                () {},
              ), // تغيير الاسم لـ Warrad
            ]),

            const SizedBox(height: 30),

            if (isLoggedIn)
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Delete My Account",
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                ),
              ),

            // 4. زر تسجيل الدخول للضيوف (بديل للقسم الشخصي)
            if (!isLoggedIn)
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    "Login to Manage Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

            const SizedBox(height: 20),
            _buildAppVersionInfo(), // معلومات الإصدار تظهر للكل
          ],
        ),
      ),
    );
  }
}

Widget _buildAppVersionInfo() {
  return Center(
    child: Column(
      children: [
        const Text(
          "Warrad Fashion", // تم تحديث الاسم ليتوافق مع مشروعك
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          "Version 1.0 May, 2026", // التاريخ المحدث بناءً على جدولك الزمني
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
      ],
    ),
  );
}

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
