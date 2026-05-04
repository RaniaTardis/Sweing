import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sweing_app/features/auth/screens/login_screen.dart';

class CartScreen extends StatefulWidget {
  final int? userId;
  const CartScreen({super.key, this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _cartItems = [];
  String? _userToken;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('userToken');
    await _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = widget.userId ?? prefs.getInt('userId');
      if (userId == null) {
        setState(() => _isLoading = false);
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/cart?userId=$userId'),
        headers: {
          if (_userToken != null) 'Authorization': 'Bearer $_userToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _cartItems = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      print('Load cart error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateQuantity(int cartId, int newQuantity) async {
    try {
      await http.put(
        Uri.parse('http://localhost:3000/cart/$cartId/quantity'),
        headers: {
          'Content-Type': 'application/json',
          if (_userToken != null) 'Authorization': 'Bearer $_userToken',
        },
        body: json.encode({'quantity': newQuantity}),
      );
      setState(() {
        final idx = _cartItems.indexWhere((i) => i['cartId'] == cartId);
        if (idx != -1) _cartItems[idx]['quantity'] = newQuantity;
      });
    } catch (e) {
      print('Update quantity error: $e');
    }
  }

  Future<void> _removeItem(int cartId) async {
    try {
      await http.delete(
        Uri.parse('http://localhost:3000/cart/$cartId'),
        headers: {
          if (_userToken != null) 'Authorization': 'Bearer $_userToken',
        },
      );
      setState(() {
        _cartItems.removeWhere((i) => i['cartId'] == cartId);
      });
    } catch (e) {
      print('Remove cart error: $e');
    }
  }

  double get _total => _cartItems.fold(
        0,
        (sum, item) =>
            sum + (item['productPrice'] as num) * (item['quantity'] as num),
      );

  @override
  Widget build(BuildContext context) {
    if (widget.userId == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined,
                  size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text('Your cart is waiting!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Login to add items and manage your orders',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Login / Sign Up',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Cart',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFFDDE3FE),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                '${_cartItems.length}',
                style: const TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadCart,
            icon: const Icon(Icons.refresh, color: Colors.grey),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) =>
                      _buildCartItem(_cartItems[index]),
                ),
      bottomSheet: _cartItems.isEmpty ? null : _buildBottomBar(),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final cartId = item['cartId'] as int;
    final quantity = item['quantity'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item['productImage'] ?? '',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['productName'] ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['productPrice']} JD',
                  style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _qtyButton(
                      icon: Icons.remove,
                      onTap: quantity > 1
                          ? () => _updateQuantity(cartId, quantity - 1)
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('$quantity',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    _qtyButton(
                      icon: Icons.add,
                      onTap: () => _updateQuantity(cartId, quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeItem(cartId),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: onTap != null ? const Color(0xFFDDE3FE) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 16,
            color: onTap != null ? Colors.blue : Colors.grey[400]),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text('Your cart is empty',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Add items from the home screen',
              style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 90,
      decoration: const BoxDecoration(color: Color(0xFFF8F9FE)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Total', style: TextStyle(color: Colors.grey)),
              Text(
                '${_total.toStringAsFixed(2)} JD',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }
}
