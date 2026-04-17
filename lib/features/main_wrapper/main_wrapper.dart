import 'package:flutter/material.dart';
import 'package:my_sweing_app/features/cart/CartScreen.dart';
import 'package:my_sweing_app/features/shop/screens/OrdersScreen.dart';
// استيراد الصفحات
import 'package:my_sweing_app/features/shop/screens/home_screen.dart';
import 'package:my_sweing_app/features/cart/Wishlist.dart'; // تأكدي من المسار الصحيح
import 'package:my_sweing_app/features/shop/screens/SettingsScreen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // قائمة الصفحات الكاملة الآن
  final List<Widget> _pages = [
    const HomeScreen(), // Index 0
    const WishlistScreen(), // Index 1
    const OrdersScreen(), // Index 2 (تمت الإضافة)
    const CartScreen(), // Index 3 (تمت الإضافة)
    const SettingsScreen(), // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدام IndexedStack يحافظ على حالة كل صفحة عند التنقل
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // ضروري لظهور الـ 5 أيقونات معاً
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false, // لإعطاء مظهر عصري وبسيط
        showUnselectedLabels: false, // يركز الانتباه على الأيقونة النشطة
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
