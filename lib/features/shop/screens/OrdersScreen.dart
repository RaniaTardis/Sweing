import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sweing_app/core/app_localizations.dart';

class OrdersScreen extends StatefulWidget {
  final int? userId;
  const OrdersScreen({super.key, this.userId});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _pendingOrders = [];
  List<Map<String, dynamic>> _deliveredOrders = [];
  String? _userToken;
  int? _effectiveUserId;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('userToken');
    _effectiveUserId = widget.userId ?? prefs.getInt('userId');
    final int? userId = _effectiveUserId;
    if (userId == null || _userToken == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final headers = {'Authorization': 'Bearer $_userToken'};

      final pendingRes = await http.get(
        Uri.parse('http://localhost:3000/orders?userId=$userId&status=pending'),
        headers: headers,
      );
      final deliveredRes = await http.get(
        Uri.parse('http://localhost:3000/orders?userId=$userId&status=delivered'),
        headers: headers,
      );

      if (mounted) {
        setState(() {
          if (pendingRes.statusCode == 200) {
            _pendingOrders = List<Map<String, dynamic>>.from(json.decode(pendingRes.body));
          }
          if (deliveredRes.statusCode == 200) {
            _deliveredOrders = List<Map<String, dynamic>>.from(json.decode(deliveredRes.body));
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Load orders error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _reorder(int orderId) async {
    if (_effectiveUserId == null || _userToken == null) return;

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_userToken',
    };

    try {
      // Fetch the original order items
      final itemsRes = await http.get(
        Uri.parse('http://localhost:3000/orders/$orderId/items'),
        headers: {'Authorization': 'Bearer $_userToken'},
      );

      if (itemsRes.statusCode != 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load order items')),
        );
        return;
      }

      final items = List<Map<String, dynamic>>.from(json.decode(itemsRes.body));
      if (items.isEmpty) return;

      int added = 0;
      for (final item in items) {
        final res = await http.post(
          Uri.parse('http://localhost:3000/cart/add'),
          headers: headers,
          body: json.encode({
            'userId': _effectiveUserId,
            'productId': item['productId'],
            'productName': item['productName'],
            'productPrice': item['productPrice'],
            'productImage': item['productImage'],
            'size': item['size'],
          }),
        );
        final data = json.decode(res.body);
        if (data['status'] == 'added' || data['status'] == 'size_updated') added++;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(added > 0
              ? '$added item${added == 1 ? '' : 's'} added to cart'
              : 'Items are already in your cart'),
          backgroundColor: added > 0 ? const Color(0xFF4CAF50) : Colors.orange,
        ),
      );
    } catch (e) {
      debugPrint('Reorder error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reorder failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (_effectiveUserId == null && !_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                loc.t('login_see_orders'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: Text(loc.t('go_to_login')),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Text(
            loc.t('my_orders'),
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _loadOrders,
              icon: const Icon(Icons.refresh, color: Colors.grey),
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: loc.t('ongoing')),
              Tab(text: loc.t('completed')),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildOrdersList(_pendingOrders),
                  _buildOrdersList(_deliveredOrders),
                ],
              ),
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    final loc = AppLocalizations.of(context);
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(loc.t('no_orders'), style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: orders.length,
        itemBuilder: (context, index) => _buildOrderCard(orders[index]),
      ),
    );
  }

  void _showTrackOrderSheet(Map<String, dynamic> order) {
    final loc = AppLocalizations.of(context);
    final orderId = order['orderId'];
    final total = (order['totalAmount'] as num).toStringAsFixed(2);
    final itemCount = order['itemCount'] ?? 0;
    final createdAt = order['createdAt'] != null
        ? DateTime.tryParse(order['createdAt'].toString())
        : null;
    final dateStr = createdAt != null
        ? '${createdAt.day} ${_monthName(createdAt.month)} ${createdAt.year}'
        : '';

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
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDE3FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_shipping_outlined, color: Colors.blueAccent, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ORD-$orderId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('$dateStr · $itemCount item${itemCount == 1 ? '' : 's'} · $total JD',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(loc.t('order_tracking'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            _buildTrackStep(
              icon: Icons.receipt_long_outlined,
              title: loc.t('order_placed_step'),
              subtitle: loc.t('order_placed_sub'),
              isDone: true,
              isLast: false,
            ),
            _buildTrackStep(
              icon: Icons.inventory_2_outlined,
              title: loc.t('processing'),
              subtitle: loc.t('processing_sub'),
              isDone: true,
              isLast: false,
            ),
            _buildTrackStep(
              icon: Icons.local_shipping_outlined,
              title: loc.t('shipped'),
              subtitle: loc.t('shipped_sub'),
              isDone: false,
              isActive: true,
              isLast: false,
            ),
            _buildTrackStep(
              icon: Icons.check_circle_outline,
              title: loc.t('delivered_step'),
              subtitle: loc.t('delivered_sub'),
              isDone: false,
              isLast: true,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      loc.t('estimated_delivery'),
                      style: TextStyle(color: Colors.orange[800], fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isLast,
    bool isActive = false,
  }) {
    final color = isDone ? const Color(0xFF4CAF50) : isActive ? Colors.blueAccent : Colors.grey[300];
    final iconColor = isDone ? Colors.white : isActive ? Colors.white : Colors.grey[400];
    final bgColor = isDone ? const Color(0xFF4CAF50) : isActive ? Colors.blueAccent : Colors.grey[200];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 16),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: color,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDone || isActive ? Colors.black87 : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDone || isActive ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isDone)
            const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20)
          else if (isActive)
            SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final loc = AppLocalizations.of(context);
    final isDelivered = order['status'] == 'delivered';
    final orderId = order['orderId'];
    final total = (order['totalAmount'] as num).toStringAsFixed(2);
    final itemCount = order['itemCount'] ?? 0;
    final createdAt = order['createdAt'] != null
        ? DateTime.tryParse(order['createdAt'].toString())
        : null;
    final dateStr = createdAt != null
        ? '${createdAt.day} ${_monthName(createdAt.month)} ${createdAt.year}'
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE3FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.receipt_long_outlined, color: Colors.blueAccent),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORD-$orderId',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (dateStr.isNotEmpty)
                      Text(
                        dateStr,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                  ],
                ),
              ),
              Text(
                isDelivered ? loc.t('delivered') : loc.t('in_progress'),
                style: TextStyle(
                  color: isDelivered ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$itemCount item${itemCount == 1 ? '' : 's'} · $total JD',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: isDelivered
                    ? () => _reorder(orderId)
                    : () => _showTrackOrderSheet(order),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDelivered ? const Color(0xFF4CAF50) : Colors.blueAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(isDelivered ? loc.t('reorder') : loc.t('track_order')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[month - 1];
  }
}
