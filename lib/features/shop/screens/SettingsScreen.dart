import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final int? userId;
  const SettingsScreen({super.key, this.userId});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _userToken;
  String _fullAddress = '';
  String _city = '';
  String _country = 'Jordan';
  String _currency = 'JOD';
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('userToken');
    _userName = prefs.getString('userName') ?? '';
    _userEmail = prefs.getString('userEmail') ?? '';
    if (mounted) {
      setState(() {
        _country = prefs.getString('country') ?? 'Jordan';
        _currency = prefs.getString('currency') ?? 'JOD';
      });
    }
    await _loadAddress();
  }

  Future<void> _loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('userToken');
    final int? userId = widget.userId ?? prefs.getInt('userId');
    if (userId == null || _userToken == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/user/address/$userId'),
        headers: {'Authorization': 'Bearer $_userToken'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _fullAddress = data['fullAddress'] ?? '';
            _city = data['city'] ?? '';
          });
        }
      }
    } catch (e) {
      debugPrint('Load address error: $e');
    }
  }

  void _showAddressSheet() {
    final fullAddressCtrl = TextEditingController(text: _fullAddress);
    final cityCtrl = TextEditingController(text: _city);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fullAddressCtrl,
              decoration: InputDecoration(
                labelText: 'Full Address',
                hintText: 'Street, building, apartment...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cityCtrl,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _saveAddress(
                  fullAddressCtrl.text.trim(),
                  cityCtrl.text.trim(),
                  ctx,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAddress(String fullAddress, String city, BuildContext sheetCtx) async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = widget.userId ?? prefs.getInt('userId');
    if (userId == null || _userToken == null) return;

    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/user/address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_userToken',
        },
        body: json.encode({'userId': userId, 'fullAddress': fullAddress, 'city': city}),
      );

      if (!mounted) return;
      Navigator.pop(sheetCtx);

      if (response.statusCode == 200) {
        setState(() {
          _fullAddress = fullAddress;
          _city = city;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address saved!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save address'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      debugPrint('Save address error: $e');
    }
  }

  void _showProfileSheet() {
    final nameCtrl = TextEditingController(text: _userName);
    final emailCtrl = TextEditingController(text: _userEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _saveProfile(nameCtrl.text.trim(), emailCtrl.text.trim(), ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile(String name, String email, BuildContext sheetCtx) async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = widget.userId ?? prefs.getInt('userId');
    if (userId == null || _userToken == null) return;

    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_userToken',
        },
        body: json.encode({'userId': userId, 'fullName': name, 'email': email}),
      );

      if (!mounted) return;
      Navigator.pop(sheetCtx);

      if (response.statusCode == 200) {
        await prefs.setString('userName', name);
        await prefs.setString('userEmail', email);
        setState(() {
          _userName = name;
          _userEmail = email;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated!'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      debugPrint('Save profile error: $e');
    }
  }

  void _showCountrySheet() {
    const countries = [
      'Jordan', 'Saudi Arabia', 'UAE', 'Kuwait', 'Qatar',
      'Bahrain', 'Oman', 'Egypt', 'Lebanon', 'Iraq',
      'Syria', 'Palestine', 'Turkey', 'USA', 'UK',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          const Text('Select Country', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: countries.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(countries[index]),
                trailing: countries[index] == _country
                    ? const Icon(Icons.check, color: Colors.blueAccent)
                    : null,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('country', countries[index]);
                  if (mounted) {
                    setState(() => _country = countries[index]);
                    Navigator.pop(ctx);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showCurrencySheet() {
    const currencies = ['JOD', 'USD', 'EUR', 'SAR', 'AED', 'KWD', 'QAR', 'BHD', 'OMR', 'EGP', 'TRY', 'GBP'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          const Text('Select Currency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(currencies[index]),
                trailing: currencies[index] == _currency
                    ? const Icon(Icons.check, color: Colors.blueAccent)
                    : null,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('currency', currencies[index]);
                  if (mounted) {
                    setState(() => _currency = currencies[index]);
                    Navigator.pop(ctx);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = widget.userId != null;
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
                _buildSettingsTile(Icons.person_outline, "Profile", _showProfileSheet,
                    trailingText: _userName.isNotEmpty ? _userName : null),
                _buildSettingsTile(
                  Icons.location_on_outlined,
                  "Shipping Address",
                  _showAddressSheet,
                  trailingText: _city.isNotEmpty ? _city : null,
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
              _buildSettingsTile(Icons.public, "Country", _showCountrySheet,
                  trailingText: _country),
              _buildSettingsTile(
                Icons.monetization_on_outlined,
                "Currency",
                _showCurrencySheet,
                trailingText: _currency,
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
              _buildSettingsTile(Icons.info_outline, "About Warrad", () {}),
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
            if (!isLoggedIn)
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: const Text(
                    "Login to Manage Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            _buildAppVersionInfo(),
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
          "Warrad Fashion",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          "Version 1.0 May, 2026",
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
