import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Cart", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFDDE3FE), borderRadius: BorderRadius.circular(20)),
              child: const Text("0", style: TextStyle(color: Colors.blue, fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // قسم عنوان الشحن (Shipping Address)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FE),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Shipping Address", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("26, Amman, Jordan - Al-Zaytoonah St.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.edit, color: Colors.white, size: 18),
                    )
                  ],
                ),
              ),
            ),

            // أيقونة السلة الفارغة
            const SizedBox(height: 40),
            Center(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade100, width: 2),
                ),
                child: const Icon(Icons.shopping_bag, size: 80, color: Colors.blue),
              ),
            ),

            // قسم من المفضلة (From Your Wishlist)
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("From Your Wishlist", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            _buildWishlistItemInCart(), // عنصر واحد للتجربة
          ],
        ),
      ),
      bottomSheet: _buildCartBottomBar(),
    );
  }

  Widget _buildWishlistItemInCart() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Container(
            height: 80, width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(image: NetworkImage("https://via.placeholder.com/150"), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Product Title...", style: TextStyle(fontSize: 14, color: Colors.grey)),
                const Text("17.00 JD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _tag("Pink"), const SizedBox(width: 5), _tag("M"),
                  ],
                )
              ],
            ),
          ),
          const Icon(Icons.add_shopping_cart, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _tag(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: const Color(0xFFDDE3FE), borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: const TextStyle(fontSize: 12)),
  );

  Widget _buildCartBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 90,
      decoration: const BoxDecoration(color: Color(0xFFF8F9FE)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total", style: TextStyle(color: Colors.grey)),
              Text("0.00 JD", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text("Checkout"),
          )
        ],
      ),
    );
  }
}