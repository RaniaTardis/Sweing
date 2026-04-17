import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
// تأكدي من استيراد صفحة التفاصيل
import 'package:my_sweing_app/features/shop/screens/product_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildSkeletonLoader() : _buildActualContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Text(
            'Shop',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActualContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0),
            child: Text(
              "Hello, Rama!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(padding: const EdgeInsets.all(15.0), child: _buildBanner()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: _buildAnnouncement(),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
            child: Text(
              "Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _buildCategoryList(),

          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Most Popular",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // هنا أعدنا قطع المنتجات مع خاصية الضغط
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: _buildProductGrid(),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductDetailsScreen(),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://via.placeholder.com/300",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        radius: 15,
                        child: const Icon(
                          Icons.favorite_border,
                          size: 18,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Floral Design",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const Text(
                "25.00 JD",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // الـ Banner والـ Announcement والـ Category بقيت كما هي...
  Widget _buildBanner() => Container(
    height: 160,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFB74D), Color(0xFFFFD54F)],
      ),
      borderRadius: BorderRadius.circular(25),
    ),
  );
  Widget _buildAnnouncement() => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F6FA),
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Row(
      children: [
        Icon(Icons.stars, color: Colors.orangeAccent),
        SizedBox(width: 10),
        Text("Claim your first order DISCOUNT now!"),
      ],
    ),
  );
  Widget _buildCategoryList() => SizedBox(
    height: 110,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFDDE3FE),
              child: Icon(Icons.checkroom, color: Colors.blueAccent),
            ),
            const SizedBox(height: 8),
            Text("Dress"),
          ],
        ),
      ),
    ),
  );

  Widget _buildSkeletonLoader() => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: const Center(child: Text("Loading...")),
  );
}
        