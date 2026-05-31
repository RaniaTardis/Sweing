import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_sweing_app/core/app_localizations.dart';
import 'package:my_sweing_app/core/constants.dart';
import 'package:my_sweing_app/features/cart/CartScreen.dart';
import 'package:my_sweing_app/features/cart/Wishlist.dart';
import 'package:my_sweing_app/features/shop/screens/AllReviewsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> dress;

  const ProductDetailsScreen({super.key, required this.dress});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String selectedSize = 'S';
  int selectedImageIndex = 0;
  bool isWishlisted = false;
  final PageController _pageController = PageController();
  bool _isAddingToCart = false;
  List<Map<String, dynamic>> _reviews = [];
  double _avgRating = 4.8;
  int _reviewCount = 1;

  late List<String> dressImages;

  @override
  void initState() {
    super.initState();
    dressImages = [
      widget.dress['image'] ?? 'assets/images/placeholder.png',
      widget.dress['image2'] ??
          widget.dress['image'] ??
          'assets/images/placeholder.png',
    ];
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final productId = widget.dress['id'];
    if (productId == null) return;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews?productId=$productId'),
      );
      if (response.statusCode == 200 && mounted) {
        final data = List<Map<String, dynamic>>.from(json.decode(response.body));
        double avg = 4.8;
        if (data.isNotEmpty) {
          avg = data.fold<num>(0, (s, r) => s + (r['rating'] as num)) / data.length;
        }
        setState(() {
          _reviews = data;
          _avgRating = avg;
          _reviewCount = data.length + 1;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _toggleWishlist() async {
    final loc = AppLocalizations.of(context);
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    final String? token = prefs.getString('userToken');

    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.t('please_login_wishlist'))),
      );
      return;
    }

    final adding = !isWishlisted;

    if (adding) {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/wishlist/add'),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'userId': userId,
            'productId': widget.dress['id'],
            'productName': widget.dress['name'],
            'productPrice': widget.dress['price'],
            'productImage': widget.dress['image'],
          }),
        );

        if (response.statusCode != 200) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.t('failed_wishlist'))),
          );
          return;
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.t('wishlist_error'))),
        );
        return;
      }
    }

    if (!mounted) return;
    setState(() => isWishlisted = adding);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          adding
              ? '${widget.dress['name']} ${loc.t('added_to_wishlist')}'
              : '${widget.dress['name']} ${loc.t('removed_from_wishlist')}',
        ),
        backgroundColor: adding ? const Color(0xFF4CAF50) : Colors.grey[700],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _addToCart() async {
    final loc = AppLocalizations.of(context);
    if (_isAddingToCart) return;
    setState(() => _isAddingToCart = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('userId');
      final String? token = prefs.getString('userToken');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.t('please_login_cart'))),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'userId': userId,
          'productId': widget.dress['id'],
          'productName': widget.dress['name'],
          'productPrice': widget.dress['price'],
          'productImage': widget.dress['image'],
          'size': selectedSize,
        }),
      );

      final data = json.decode(response.body);
      final status = data['status'];

      if (!mounted) return;
      final String message;
      final Color color;
      if (status == 'already_in_cart') {
        message = '${widget.dress['name']} ${loc.t('already_in_cart')}';
        color = Colors.orange;
      } else if (status == 'size_updated') {
        message = loc.t('size_updated', params: {'size': selectedSize});
        color = Colors.blue;
      } else {
        message = '${widget.dress['name']} ${loc.t('added_to_cart')}';
        color = const Color(0xFF4CAF50);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.t('cart_error'))),
      );
    } finally {
      if (mounted) setState(() => _isAddingToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final dress = widget.dress;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            onPressed: _toggleWishlist,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(isWishlisted),
                color: isWishlisted ? Colors.red : Colors.black,
                size: 26,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getInt('userId');
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen(userId: userId)),
              );
            },
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              height: 380,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => selectedImageIndex = index);
                      },
                      itemCount: dressImages.length,
                      itemBuilder: (context, index) {
                        return InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(20),
                          minScale: 0.5,
                          maxScale: 4.0,
                          panEnabled: true,
                          transformationController: TransformationController(),
                          child: Image.asset(
                            dressImages[index],
                            fit: BoxFit.contain,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.image_not_supported,
                                        size: 64, color: Colors.grey),
                                    const SizedBox(height: 8),
                                    Text(loc.t('image_not_available'),
                                        style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: _toggleWishlist,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isWishlisted
                                ? Colors.red.withOpacity(0.15)
                                : Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isWishlisted ? Colors.red : Colors.grey[600],
                            size: 22,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(dressImages.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: selectedImageIndex == index ? 24 : 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedImageIndex == index
                                  ? Colors.black
                                  : Colors.white.withOpacity(0.8),
                              border:
                                  Border.all(color: Colors.white, width: 2),
                            ),
                          );
                        }),
                      ),
                    ),

                    if (dressImages.length > 1) ...[
                      Positioned(
                        left: 10,
                        top: MediaQuery.of(context).size.height * 0.4 - 20,
                        child: GestureDetector(
                          onTap: selectedImageIndex > 0
                              ? () => _pageController.previousPage(
                                    duration:
                                        const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: MediaQuery.of(context).size.height * 0.4 - 20,
                        child: GestureDetector(
                          onTap: selectedImageIndex < dressImages.length - 1
                              ? () => _pageController.nextPage(
                                    duration:
                                        const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dress['name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${dress['category']} • ${loc.t('premium_quality')}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${dress['price']} JD",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(loc.t('size'),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {},
                        child: Text(loc.t('size_guide'),
                            style: const TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['S', 'M', 'L', 'XL', '2XL'].map((size) {
                      bool isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSize = size),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF4CAF50)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF4CAF50)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  Text(loc.t('description'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    loc.t('description_template', params: {'name': dress['name'], 'category': dress['category']}),
                    style: const TextStyle(
                        color: Colors.black87, height: 1.6, fontSize: 16),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${loc.t('reviews')} ($_reviewCount)",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllReviewsScreen(
                                productId: widget.dress['id'],
                              ),
                            ),
                          ).then((_) => _loadReviews());
                        },
                        child: Text(loc.t('view_all_reviews'),
                            style: const TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                  () {
                    final preview = _reviews.isNotEmpty ? _reviews.first : null;
                    final name = preview != null ? (preview['userName'] ?? 'User') : 'Ronald Richards';
                    final rating = preview != null ? (preview['rating'] as num).toInt() : 5;
                    final comment = preview != null
                        ? (preview['comment'] ?? '')
                        : 'Absolutely stunning dress! Perfect fit and quality. Highly recommend!';
                    final dateRaw = preview != null ? preview['createdAt'] : '2020-09-13T00:00:00';
                    String dateStr = '13 Sep, 2020';
                    if (dateRaw != null) {
                      final dt = DateTime.tryParse(dateRaw.toString());
                      if (dt != null) {
                        const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                        dateStr = '${dt.day} ${months[dt.month - 1]}, ${dt.year}';
                      }
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                          ),
                          title: Text(name),
                          subtitle: Text(dateStr),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${_avgRating.toStringAsFixed(1)} ${loc.t('rating')}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  5,
                                  (i) => Icon(Icons.star,
                                      size: 14,
                                      color: i < rating
                                          ? Colors.amber
                                          : Colors.grey[300]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 72),
                          child: Text(comment,
                              style: const TextStyle(color: Colors.grey)),
                        ),
                      ],
                    );
                  }(),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  if (!isWishlisted) await _toggleWishlist();
                  if (!mounted) return;
                  final prefs = await SharedPreferences.getInstance();
                  final userId = prefs.getInt('userId');
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WishlistPage(userId: userId)),
                  );
                },
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFF4CAF50),
                ),
                label: Text(
                  isWishlisted ? loc.t('in_wishlist') : loc.t('add_to_wishlist'),
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF4CAF50)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isAddingToCart ? null : _addToCart,
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: Text(
                  _isAddingToCart ? loc.t('adding') : loc.t('add_to_cart'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
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
