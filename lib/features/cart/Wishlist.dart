import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Wishlist",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              // سطر 36 المسبب للمشكلة
              mainAxisSize: MainAxisSize.max,
              children: [
                // 1. الصورة بحجم ثابت ومحدد تماماً
                SizedBox(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://via.placeholder.com/100",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 2. استخدمنا Expanded هنا لامتصاص كل المساحة المتبقية
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Elegant Dress for Special Occasions", // نص طويل للتجربة
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "25.00 JD",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. زر الحذف مع تقييد مساحته
                SizedBox(
                  width: 40,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
