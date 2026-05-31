import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sweing_app/features/auth/screens/login_screen.dart';
import 'package:my_sweing_app/core/constants.dart';
import 'package:my_sweing_app/core/app_localizations.dart';

class CartScreen extends StatefulWidget {
  final int? userId;
  final VoidCallback? onOrderPlaced;
  const CartScreen({super.key, this.userId, this.onOrderPlaced});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _cartItems = [];
  String? _userToken;
  int? _effectiveUserId;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('userToken');
    _effectiveUserId = widget.userId ?? prefs.getInt('userId');
    await _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    try {
      final userId = _effectiveUserId;
      if (userId == null) {
        setState(() => _isLoading = false);
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/cart?userId=$userId'),
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
      debugPrint('Load cart error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateQuantity(int cartId, int newQuantity) async {
    try {
      await http.put(
        Uri.parse('$baseUrl/cart/$cartId/quantity'),
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
      debugPrint('Update quantity error: $e');
    }
  }

  Future<void> _removeItem(int cartId) async {
    try {
      await http.delete(
        Uri.parse('$baseUrl/cart/$cartId'),
        headers: {
          if (_userToken != null) 'Authorization': 'Bearer $_userToken',
        },
      );
      setState(() {
        _cartItems.removeWhere((i) => i['cartId'] == cartId);
      });
    } catch (e) {
      debugPrint('Remove cart error: $e');
    }
  }

  Future<void> _checkout() async {
    final int? userId = _effectiveUserId;
    if (userId == null || _userToken == null) return;

    try {
      final addrResponse = await http.get(
        Uri.parse('$baseUrl/user/address/$userId'),
        headers: {'Authorization': 'Bearer $_userToken'},
      );

      if (addrResponse.statusCode != 200) {
        if (!mounted) return;
        final loc = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.t('set_address_settings')),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final addrData = json.decode(addrResponse.body) as Map<String, dynamic>;
      if (addrData.isEmpty || (addrData['fullAddress'] ?? '').isEmpty) {
        if (!mounted) return;
        final loc = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.t('set_address_settings')),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (!mounted) return;
      _showConfirmationSheet(userId, addrData);
    } catch (e) {
      debugPrint('Checkout address check error: $e');
    }
  }

  void _showConfirmationSheet(int userId, Map<String, dynamic> address) {
    final loc = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.t('confirm_order'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${address['fullAddress']}, ${address['city']}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(loc.t('items'), style: const TextStyle(color: Colors.grey)),
                Text('${_cartItems.length}'),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(loc.t('total'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  '${_total.toStringAsFixed(2)} JD',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF4CAF50)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _placeOrder(userId, ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  loc.t('confirm_order'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder(int userId, BuildContext sheetCtx) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/checkout'),
        headers: {
          'Content-Type': 'application/json',
          if (_userToken != null) 'Authorization': 'Bearer $_userToken',
        },
        body: json.encode({'userId': userId}),
      );

      if (!mounted) return;
      final loc = AppLocalizations.of(context);
      Navigator.pop(sheetCtx);

      if (response.statusCode == 200) {
        setState(() => _cartItems.clear());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.t('order_placed')),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
        widget.onOrderPlaced?.call();
      } else {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['error'] ?? 'Checkout failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Place order error: $e');
    }
  }

  double get _total => _cartItems.fold(
        0,
        (sum, item) =>
            sum + (item['productPrice'] as num) * (item['quantity'] as num),
      );

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (_effectiveUserId == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              Text(loc.t('your_cart_waiting'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(loc.t('login_add_items'),
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(loc.t('login_sign_up'),
                    style: const TextStyle(color: Colors.white)),
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
            Text(loc.t('cart'),
                style: const TextStyle(
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
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 110),
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
            child: (item['productImage'] ?? '').toString().startsWith('http')
                ? Image.network(
                    item['productImage'] as String,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80, height: 80, color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  )
                : Image.asset(
                    item['productImage'] ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80, height: 80, color: Colors.grey[200],
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${item['productPrice']} JD',
                      style: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    if (item['size'] != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDE3FE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Size: ${item['size']}',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ],
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
    final loc = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(loc.t('your_cart_empty'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(loc.t('add_items_home'),
              style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final loc = AppLocalizations.of(context);
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
              Text(loc.t('total'), style: const TextStyle(color: Colors.grey)),
              Text(
                '${_total.toStringAsFixed(2)} JD',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _checkout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(loc.t('checkout')),
          ),
        ],
      ),
    );
  }
}
