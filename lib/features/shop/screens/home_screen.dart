import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_sweing_app/core/app_localizations.dart';
import 'package:my_sweing_app/features/auth/screens/login_screen.dart';
import 'package:my_sweing_app/features/auth/screens/signup_screen.dart';
import 'package:my_sweing_app/features/shop/screens/CategoryProductsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:my_sweing_app/features/shop/screens/product_details.dart';

class HomeScreen extends StatefulWidget {
  final int? userId;
  const HomeScreen({super.key, this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<bool> _isFavorited = List.filled(12, false);
  String? _guestSessionId;
  String? _userToken;
  bool _isGuest = false;
  late final List<Map<String, dynamic>> dresses;
  late final List<Map<String, dynamic>> categories;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> get _filteredDresses {
    if (_searchQuery.isEmpty) return dresses;
    final q = _searchQuery.toLowerCase();
    return dresses.where((d) {
      final name = (d['name'] ?? '').toString().toLowerCase();
      final cat = (d['category'] ?? '').toString().toLowerCase();
      return name.contains(q) || cat.contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dresses = [
      {
        'id': 1,
        'name': 'Elegant Red Gown',
        'price': 45.00,
        'image': 'assets/images/black_2.png',
        'image2': 'assets/images/black.png',
        'category': 'Buy',
      },
      {
        'id': 2,
        'name': 'Classic Black Dress',
        'price': 35.00,
        'image': 'assets/images/darkBlue_2.png',
        'category': 'Buy',
      },
      {
        'id': 3,
        'name': 'Bridal White Gown',
        'price': 120.00,
        'image': 'assets/images/lightBlue_2.png',
        'category': 'Rent',
      },
      {
        'id': 4,
        'name': 'Evening Blue Dress',
        'price': 55.00,
        'image': 'assets/images/lightPinkFlower.png',
        'category': 'Buy',
      },
      {
        'id': 5,
        'name': 'Party Pink Gown',
        'price': 65.00,
        'image': 'assets/images/lightStracBlue_2.png',
        'category': 'Buy',
      },
      {
        'id': 6,
        'name': 'Custom Floral',
        'price': 85.00,
        'image': 'assets/images/lightstracPink_2.png',
        'category': 'Custom',
      },
      {
        'id': 7,
        'name': 'Golden Evening',
        'price': 75.00,
        'image': 'assets/images/stracGreen_2.png',
        'category': 'Rent',
      },
      {
        'id': 8,
        'name': 'Lace Wedding',
        'price': 95.00,
        'image': 'assets/images/yellow_2.png',
        'category': 'Custom',
      },
      {
        'id': 9,
        'name': 'Summer Maxi',
        'price': 28.00,
        'image': 'assets/images/darkBlue_3.png',
        'category': 'Buy',
      },
      {
        'id': 10,
        'name': 'Velvet Red',
        'price': 60.00,
        'image': 'assets/images/red_2.png',
        'category': 'Rent',
      },
      {
        'id': 11,
        'name': 'Silk Custom',
        'price': 110.00,
        'image': 'assets/images/gray_2.png',
        'category': 'Custom',
      },
      {
        'id': 12,
        'name': 'Chic Cocktail',
        'price': 40.00,
        'image': 'assets/images/skin_2.png',
        'category': 'Buy',
      },
    ];

    categories = [
      {
        'title': 'Buy Dresses',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFF4CAF50),
        'image': 'assets/images/buy-dress.png',
      },
      {
        'title': 'Rent Dresses',
        'icon': Icons.repeat,
        'color': const Color(0xFFFF9800),
        'image': 'assets/images/rent-dress.png',
      },
      {
        'title': 'Custom Made',
        'icon': Icons.content_cut,
        'color': const Color(0xFF2196F3),
        'image': 'assets/images/custom-dress.png',
      },
    ];
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _userToken = prefs.getString('userToken');
      _guestSessionId = prefs.getString('guestSessionId');
      int? savedUserId = prefs.getInt('userId');

      setState(() {
        _isGuest = (_userToken == null);
        _isFavorited = List.filled(dresses.length, false);
      });

      if (_userToken != null || _guestSessionId != null) {
        await _loadFavorites();
      }
    } catch (e) {
      print('Error in _checkAuthStatus: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _isLoading ? _buildSkeletonLoader() : _buildActualContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final loc = AppLocalizations.of(context);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
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
              Icons.local_florist,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            loc.t('sewing_elegance'),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 24,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink.shade100, Colors.purple.shade100],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.pink.shade200, width: 1),
            ),
            child: IconButton(
              onPressed: () => _showAccountOptions(),
              icon: Icon(
                _isGuest ? Icons.account_circle_outlined : Icons.account_circle,
                size: 24,
                color: Colors.pink.shade700,
              ),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[600]),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: loc.t('search_hint'),
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                    border: InputBorder.none,
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAccountOptions() {
    final loc = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            if (_isGuest) ...[
              _buildAccountOption(
                Icons.login,
                loc.t('login'),
                loc.t('access_account'),
                Colors.blue,
                action: () {
                  Navigator.push(
                    this.context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
              _buildAccountOption(
                Icons.person_add,
                loc.t('create_account'),
                loc.t('create_account_subtitle'),
                Colors.green,
                action: () {
                  Navigator.push(
                    this.context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
              ),
            ] else ...[
              _buildAccountOption(
                Icons.logout,
                loc.t('logout'),
                loc.t('logout_subtitle'),
                Colors.red,
                action: () {
                  _logout();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption(
    IconData icon,
    String title,
    String subtitle,
    Color color, {
    VoidCallback? action,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.pop(context);
          action?.call();
        },
      ),
    );
  }

  Future<void> _logout() async {
    final loc = AppLocalizations.of(context);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    await prefs.remove('guestSessionId');
    setState(() {
      _isGuest = true;
      _userToken = null;
      _guestSessionId = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.t('logged_out'))),
    );
  }

  Future<void> _loadFavorites() async {
    try {
      final headers = {
        if (_userToken != null) 'Authorization': 'Bearer $_userToken',
        if (_guestSessionId != null) 'Guest-Session': _guestSessionId!,
      };

      final response = await http.get(
        Uri.parse(
          'http://localhost:3000/wishlist?userId=${widget.userId ?? 1}',
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final favoriteIds = (data as List)
            .map((item) => item['productId'])
            .toList();

        setState(() {
          for (int id in favoriteIds) {
            if (id <= _isFavorited.length) {
              _isFavorited[id - 1] = true;
            }
          }
        });
        print('✅ Loaded ${favoriteIds.length} favorites');
      }
    } catch (e) {
      print('Load favorites error: $e');
    }
  }

  Future<void> _login(String email, String password) async {
    final loc = AppLocalizations.of(context);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', data['token']);

        setState(() {
          _userToken = data['token'];
          _isGuest = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.t('welcome_back'))));
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  Widget _buildActualContent() {
    final loc = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(seconds: 1));
        setState(() => _isLoading = false);
      },
      color: const Color(0xFF4CAF50),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroBanner(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.t('shop_by_category'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          loc.t('see_all'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildCategoriesSection(),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.t('most_popular'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          loc.t('view_all'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: _buildProductGrid(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    final loc = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1578480163345-eb37b9d2aaea?w=1200&h=500&fit=crop',
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ ${loc.t('hero_title')}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.t('hero_subtitle'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {},
                  child: Text(
                    loc.t('shop_now'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(
            category['title'],
            category['icon'],
            category['color'],
            category['image'],
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    IconData icon,
    Color color,
    String imagePath,
  ) {
    final loc = AppLocalizations.of(context);
    String localizedTitle;
    switch (title) {
      case 'Buy Dresses':
        localizedTitle = loc.t('buy_dresses');
        break;
      case 'Rent Dresses':
        localizedTitle = loc.t('rent_dresses');
        break;
      case 'Custom Made':
        localizedTitle = loc.t('custom_made');
        break;
      default:
        localizedTitle = title;
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(
              categoryName: title,
              allProducts: dresses,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: imagePath.startsWith('assets/')
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(icon, color: color, size: 28),
                      ),
                    )
                  : Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                localizedTitle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Buy':
        return const Color(0xFF4CAF50);
      case 'Rent':
        return const Color(0xFFFF9800);
      case 'Custom':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  Future<void> _toggleWishlist(int productId) async {
    final loc = AppLocalizations.of(context);
    try {
      final dress = dresses.firstWhere((d) => d['id'] == productId);

      const url = 'http://localhost:3000/wishlist/add';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (_userToken != null) 'Authorization': 'Bearer $_userToken',
          if (_guestSessionId != null) 'Guest-Session': _guestSessionId!,
        },
        body: json.encode({
          'userId': _isGuest ? null : widget.userId ?? 1,
          'productId': productId,
          'productName': dress['name'],
          'productPrice': dress['price'],
          'productImage': dress['image'],
        }),
      );

      print('❤️ Wishlist Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isFavorited[productId - 1] = !_isFavorited[productId - 1];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorited[productId - 1]
                  ? '${dress['name']} ${loc.t('added_to_wishlist')}'
                  : '${dress['name']} ${loc.t('removed_from_wishlist')}',
            ),
            backgroundColor: _isFavorited[productId - 1]
                ? Colors.pink
                : Colors.grey,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Wishlist error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.t('network_error')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addToCart(int productId) async {
    final loc = AppLocalizations.of(context);
    final prefs = await SharedPreferences.getInstance();
    final int? userId = widget.userId ?? prefs.getInt('userId');
    final String? token = prefs.getString('userToken');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.t('please_login_cart'))),
      );
      return;
    }

    try {
      final dress = dresses.firstWhere((d) => d['id'] == productId);

      final response = await http.post(
        Uri.parse('http://localhost:3000/cart/add'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'userId': userId,
          'productId': productId,
          'productName': dress['name'],
          'productPrice': dress['price'],
          'productImage': dress['image'],
        }),
      );

      final data = json.decode(response.body);
      final isAlready = data['status'] == 'already_in_cart';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isAlready ? Icons.info_outline : Icons.shopping_cart,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(isAlready
                  ? '${dress['name']} ${loc.t('already_in_cart')}'
                  : '${dress['name']} ${loc.t('added_to_cart')}'),
            ],
          ),
          backgroundColor:
              isAlready ? Colors.orange : const Color(0xFF4CAF50),
        ),
      );
    } catch (e) {
      print('Cart error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.t('cart_error'))),
      );
    }
  }

  Widget _buildProductGrid() {
    final loc = AppLocalizations.of(context);
    final filtered = _filteredDresses;
    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text('${loc.t('no_results')} "$_searchQuery"',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16)),
            ],
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.78,
        mainAxisExtent: 280,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final dress = filtered[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(dress: dress),
            ),
          ),
          child: Container(
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        child: Image.asset(
                          dress['image'] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 180,
                                color: Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      loc.t('image_not_found'),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(
                              dress['category'],
                            ).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            dress['category'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () =>
                              _toggleWishlist(dress['id']),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              _isFavorited[dress['id'] - 1]
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isFavorited[dress['id'] - 1]
                                  ? Colors.red
                                  : Colors.grey[600],
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -8,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => _addToCart(dress['id']),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF4CAF50),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            dress['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${dress['price']?.toString() ?? '0'} JD',
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 180,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 160,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Container(
                width: 150,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.78,
                  mainAxisExtent: 280,
                ),
                itemCount: 6,
                itemBuilder: (_, __) => Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
