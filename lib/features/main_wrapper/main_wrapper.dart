import 'package:flutter/material.dart';
import 'package:my_sweing_app/core/app_localizations.dart';
import 'package:my_sweing_app/features/cart/CartScreen.dart';
import 'package:my_sweing_app/features/shop/screens/OrdersScreen.dart';
import 'package:my_sweing_app/features/shop/screens/home_screen.dart';
import 'package:my_sweing_app/features/cart/Wishlist.dart';
import 'package:my_sweing_app/features/shop/screens/SettingsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;
  int? currentUserId;
  bool _isInitializing = true;
  int _wishlistKey = 0;
  int _cartKey = 0;
  int _ordersKey = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          currentUserId = prefs.getInt('userId');
          _isInitializing = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  void _onOrderPlaced() {
    setState(() {
      _ordersKey++;
      _selectedIndex = 2;
    });
  }

  List<Widget> _buildPages() {
    return [
      HomeScreen(userId: currentUserId),

      currentUserId != null
          ? WishlistPage(key: ValueKey(_wishlistKey), userId: currentUserId!)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).t('please_login_orders'),
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),

      OrdersScreen(key: ValueKey(_ordersKey), userId: currentUserId),
      CartScreen(
        key: ValueKey(_cartKey),
        userId: currentUserId,
        onOrderPlaced: _onOrderPlaced,
      ),
      SettingsScreen(userId: currentUserId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (_isInitializing) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.blueAccent),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _buildPages()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            if (index == 1) _wishlistKey++;
            if (index == 2) _ordersKey++;
            if (index == 3) _cartKey++;
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 10,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: loc.t('home_label'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            activeIcon: const Icon(Icons.favorite),
            label: loc.t('my_wishlist'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined),
            activeIcon: const Icon(Icons.assignment),
            label: loc.t('my_orders'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag_outlined),
            activeIcon: const Icon(Icons.shopping_bag),
            label: loc.t('cart'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: loc.t('profile'),
          ),
        ],
      ),
    );
  }
}
