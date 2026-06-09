import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sweing_app/features/shop/screens/product_details.dart';
import 'package:my_sweing_app/core/app_localizations.dart';
import 'package:my_sweing_app/core/constants.dart';

class WishlistPage extends StatefulWidget {
   final int? userId;
  const WishlistPage({super.key, this.userId});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> wishlistItems = [];
  String? _guestSessionId;
  String? _userToken;
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    await _checkAuthStatus();
    await _loadWishlist();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('userToken');
    _guestSessionId = prefs.getString('guestSessionId');
    setState(() {
      _isGuest = _userToken == null;
    });
  }

  Future<void> _loadWishlist() async {
  try {
    setState(() => _isLoading = true);

    final headers = {
      if (_userToken != null) 'Authorization': 'Bearer $_userToken',
      if (_guestSessionId != null) 'Guest-Session': _guestSessionId!,
    };

    final prefs = await SharedPreferences.getInstance();
    final int? userId = widget.userId ?? prefs.getInt('userId');

    String url = '$baseUrl/wishlist';
    if (userId != null) {
      url += '?userId=$userId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        wishlistItems = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  } catch (e) {
    print('Load wishlist error: $e');
    setState(() => _isLoading = false);
  }
}

Future<void> _toggleWishlist(int productId) async {
  final loc = AppLocalizations.of(context);
  try {
    final item = wishlistItems.firstWhere((i) => i['productId'] == productId);
    final wishlistId = item['wishlistId'];

    final response = await http.delete(
      Uri.parse('$baseUrl/wishlist/$wishlistId'),
      headers: {
        if (_userToken != null) 'Authorization': 'Bearer $_userToken',
        if (_guestSessionId != null) 'Guest-Session': _guestSessionId!,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        wishlistItems.removeWhere((item) => item['productId'] == productId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(loc.t('removed_wishlist')),
          backgroundColor: Colors.grey,
        ),
      );
    }
  } catch (e) {
    print('Toggle wishlist error: $e');
  }
}

  Future<void> _addToCart(int productId) async {
    final loc = AppLocalizations.of(context);
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = widget.userId ?? prefs.getInt('userId');

      final item = wishlistItems.firstWhere((i) => i['productId'] == productId);

      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: {
          'Content-Type': 'application/json',
          if (_userToken != null) 'Authorization': 'Bearer $_userToken',
        },
        body: json.encode({
          'userId': userId,
          'productId': productId,
          'productName': item['productName'],
          'productPrice': item['productPrice'],
          'productImage': item['productImage'],
        }),
      );

      final data = json.decode(response.body);
      final isAlready = data['status'] == 'already_in_cart';

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAlready
              ? '${item['productName']} ${loc.t('already_in_cart')}'
              : '${item['productName']} ${loc.t('added_to_cart')}'),
          backgroundColor:
              isAlready ? Colors.orange : const Color(0xFF4CAF50),
        ),
      );
    } catch (e) {
      print('Add to cart error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              loc.t('my_wishlist'),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadWishlist,
            icon: const Icon(Icons.refresh, color: Colors.grey),
          ),
        ],
      ),
      body: _isLoading
          ? _buildSkeletonLoader()
          : wishlistItems.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadWishlist,
                  color: const Color(0xFF4CAF50),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: wishlistItems.length,
                    itemBuilder: (context, index) {
                      final item = wishlistItems[index];
                      return _buildWishlistItem(item);
                    },
                  ),
                ),
    );
  }

  Widget _buildWishlistItem(Map<String, dynamic> item) {
    final loc = AppLocalizations.of(context);
    final imageUrl = item['productImage'] ?? '';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              dress: {
                'id': item['productId'],
                'name': item['productName'],
                'price': item['productPrice'],
                'image': item['productImage'],
                'category': 'Buy',
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        width: 90,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : Image.asset(
                        imageUrl,
                        width: 90,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['productName'] ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${item['productPrice']?.toString() ?? '0'} JD',
                      style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Right column: remove + add to cart
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _toggleWishlist(item['productId']),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _addToCart(item['productId']),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Color(0xFF4CAF50),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 90,
      height: 100,
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  Widget _buildEmptyState() {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              loc.t('wishlist_empty'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              loc.t('wishlist_empty_sub'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: Text(
                loc.t('continue_shopping'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
