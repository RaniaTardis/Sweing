import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_sweing_app/core/app_localizations.dart';
import 'package:my_sweing_app/main.dart';
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
  String _selectedLanguage = 'English';

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
        _selectedLanguage =
            prefs.getString('locale') == 'ar' ? 'العربية' : 'English';
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
    final loc = AppLocalizations.of(context);
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
            Text(
              loc.t('enter_shipping_address'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fullAddressCtrl,
              decoration: InputDecoration(
                labelText: loc.t('full_address'),
                hintText: loc.t('address_hint'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cityCtrl,
              decoration: InputDecoration(
                labelText: loc.t('city'),
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
                child: Text(
                  loc.t('save'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
        if (mounted) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.t('address_saved')),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.t('failed_address')), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      debugPrint('Save address error: $e');
    }
  }

  void _showProfileSheet() {
    final loc = AppLocalizations.of(context);
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
            Text(
              loc.t('edit_profile'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: loc.t('full_name'),
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: loc.t('email'),
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
                child: Text(
                  loc.t('save'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
        if (mounted) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.t('profile_updated')), backgroundColor: Colors.green),
          );
        }
      } else {
        if (mounted) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.t('failed_update')), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      debugPrint('Save profile error: $e');
    }
  }

  void _showCountrySheet() {
    final loc = AppLocalizations.of(context);
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
          Text(loc.t('select_country'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    final loc = AppLocalizations.of(context);
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
          Text(loc.t('select_currency'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  void _showLanguageSheet() {
    final loc = AppLocalizations.of(context);
    final languages = [
      {'code': 'en', 'name': loc.t('english')},
      {'code': 'ar', 'name': loc.t('arabic')},
    ];
    final currentCode = Localizations.localeOf(context).languageCode;

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
          Text(loc.t('select_language'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(languages[index]['name']!),
                trailing: languages[index]['code'] == currentCode
                    ? const Icon(Icons.check, color: Colors.blueAccent)
                    : null,
                onTap: () async {
                  final provider = WarradApp.providerOf(this.context);
                  await provider?.setLocale(languages[index]['code']!);
                  if (mounted) {
                    setState(() {
                      _selectedLanguage = languages[index]['name']!;
                    });
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
    final loc = AppLocalizations.of(context);
    final bool isLoggedIn = widget.userId != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          loc.t('settings'),
          style: const TextStyle(
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
              _buildSectionTitle(loc.t('personal')),
              _buildSettingsGroup([
                _buildSettingsTile(Icons.person_outline, loc.t('profile'), _showProfileSheet,
                    trailingText: _userName.isNotEmpty ? _userName : null),
                _buildSettingsTile(
                  Icons.location_on_outlined,
                  loc.t('shipping_address'),
                  _showAddressSheet,
                  trailingText: _city.isNotEmpty ? _city : null,
                ),
                _buildSettingsTile(
                  Icons.payment_outlined,
                  loc.t('payment_methods'),
                  () {},
                ),
              ]),
              const SizedBox(height: 25),
            ],
            _buildSectionTitle(loc.t('shop')),
            _buildSettingsGroup([
              _buildSettingsTile(Icons.public, loc.t('country'), _showCountrySheet,
                  trailingText: _country),
              _buildSettingsTile(
                Icons.monetization_on_outlined,
                loc.t('currency'),
                _showCurrencySheet,
                trailingText: _currency,
              ),
            ]),
            const SizedBox(height: 25),
            _buildSectionTitle(loc.t('account')),
            _buildSettingsGroup([
              _buildSettingsTile(
                Icons.language,
                loc.t('language'),
                _showLanguageSheet,
                trailingText: _selectedLanguage,
              ),
              _buildSettingsTile(Icons.info_outline, loc.t('about_warrad'), () {}),
            ]),
            const SizedBox(height: 30),
            if (isLoggedIn)
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    loc.t('delete_account'),
                    style: const TextStyle(color: Colors.redAccent, fontSize: 16),
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
                  child: Text(
                    loc.t('login_manage'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            _buildAppVersionInfo(context),
          ],
        ),
      ),
    );
  }
}

Widget _buildAppVersionInfo(BuildContext context) {
  final loc = AppLocalizations.of(context);
  return Center(
    child: Column(
      children: [
        Text(
          loc.t('app_title'),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          loc.t('version_info'),
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
