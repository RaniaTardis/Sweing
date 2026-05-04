import 'package:flutter/material.dart';
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
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Please login to view your wishlist",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
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
