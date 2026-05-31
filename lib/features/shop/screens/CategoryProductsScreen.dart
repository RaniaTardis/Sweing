import 'package:flutter/material.dart';
import 'package:my_sweing_app/core/app_localizations.dart';
import 'package:my_sweing_app/features/shop/screens/product_details.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> allProducts;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.allProducts,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    String searchKey = "";
    if (categoryName == 'Buy Dresses') {
      searchKey = 'Buy';
    } else if (categoryName == 'Rent Dresses') {
      searchKey = 'Rent';
    } else if (categoryName == 'Custom Made') {
      searchKey = 'Custom';
    }

    final filteredProducts = searchKey.isEmpty
        ? List<Map<String, dynamic>>.from(allProducts)
        : allProducts.where((dress) => dress['category'] == searchKey).toList();

    Color getCategoryColor(String category) {
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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(loc.t('sort'), style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
      body: filteredProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.t('no_dresses', params: {'category': categoryName}),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.t('check_back'),
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 280,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final dress = filteredProducts[index];
                return _buildProductCard(
                  context,
                  dress,
                  getCategoryColor(searchKey),
                  loc,
                );
              },
            ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Map<String, dynamic> dress,
    Color categoryColor,
    AppLocalizations loc,
  ) {
    bool isFavorited = false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(dress: dress),
          ),
        );
      },
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
                    child: (dress['image'] ?? '').toString().startsWith('http')
                      ? Image.network(
                          dress['image'] as String,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 50, color: Color.fromARGB(255, 175, 175, 175)),
                          ),
                        )
                      : Image.asset(
                          dress['image'] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 50, color: Color.fromARGB(255, 175, 175, 175)),
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
                        color: categoryColor.withOpacity(0.9),
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
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${dress['name']} ${loc.t('added_to_wishlist')}',
                            ),
                          ),
                        );
                      },
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
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : Colors.grey[600],
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -8,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${dress['name']} ${loc.t('added_to_cart')}'),
                          ),
                        );
                      },
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
  }
}
