import 'package:flutter/material.dart';
import 'package:my_sweing_app/features/shop/screens/AllReviewsScreen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String selectedSize = 'S';
  int selectedColorIndex = 0;

  final List<Color> colors = [
    const Color(0xFF4A1D1D), // اللون الغامق
    const Color(0xFFF29494), // اللون الوردي
    const Color(0xFF3B1A1A), // اللون البني
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. صورة المنتج مع اختيار الألوان الجانبي
            Stack(
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  color: const Color(0xFFE5E5E5),
                  child: Image.network(
                    "https://via.placeholder.com/400x600", // استبدلها بصورة المنتج
                    fit: BoxFit.contain,
                  ),
                ),
                // دوائر اختيار اللون الجانبية
                Positioned(
                  left: 20,
                  top: 50,
                  child: Column(
                    children: List.generate(colors.length, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedColorIndex = index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColorIndex == index
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: colors[index],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. العنوان والسعر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Nike Club Fleece",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Men's Printed Pullover Hoodie",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      const Text(
                        "120 JD",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // 3. اختيار المقاس
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Size",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Size Guide",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['S', 'M', 'L', 'XL', '2XL'].map((size) {
                      bool isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSize = size),
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFDDE3FE)
                                : const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            size,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.blueAccent
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  // 4. الوصف
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "The Nike Throwback Pullover Hoodie is made from premium French terry fabric that blends a performance feel with... Read More..",
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),

                  const SizedBox(height: 25),

                  // 5. المراجعات (Reviews)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllReviewsScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "View All",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://via.placeholder.com/150",
                      ),
                    ),
                    title: const Text("Ronald Richards"),
                    subtitle: const Text("13 Sep, 2020"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "4.8 rating",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star,
                              size: 12,
                              color: i < 4 ? Colors.orange : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 100), // مساحة للأزرار السفلية
                ],
              ),
            ),
          ],
        ),
      ),
      // 6. الأزرار السفلية (Fixed Bottom Bar)
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Color(0xFFDDE3FE)),
                  backgroundColor: const Color(0xFFDDE3FE).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Add to washList",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xFFDDE3FE),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
