import 'package:flutter/material.dart';

class AllReviewsScreen extends StatefulWidget {
  const AllReviewsScreen({super.key});

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Reviews", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. ملخص التقييمات العلوي
          _buildReviewSummary(),
          const Divider(thickness: 1, height: 30),
          
          // 2. قائمة المراجعات
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5, // عدد تجريبي
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) => _buildReviewItem(),
            ),
          ),
        ],
      ),
      // 3. زر إضافة مراجعة جديدة
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReviewSheet(context),
        backgroundColor: const Color(0xFFDDE3FE),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.edit_note),
        label: const Text("Add Review"),
      ),
    );
  }

  // ويدجت ملخص التقييم (النجوم والمتوسط)
  Widget _buildReviewSummary() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("4.8", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (i) => Icon(Icons.star, size: 18, color: i < 4 ? Colors.orange : Colors.grey[300])),
              ),
              const SizedBox(height: 5),
              const Text("124 Reviews", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const Spacer(),
          // هنا يمكنك إضافة أشرطة التقدم (Progress Bars) لكل نجمة إذا أردت لاحقاً
        ],
      ),
    );
  }

  // ويدجت تعليق الشخص الواحد
  Widget _buildReviewItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("https://via.placeholder.com/150"),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Ronald Richards", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("13 Sep, 2020", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            Row(
              children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < 4 ? Colors.orange : Colors.grey[300])),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "The material is very high quality and the fit is perfect for daily use. I really recommend this product to everyone looking for comfort.",
          style: TextStyle(color: Colors.black87, height: 1.4),
        ),
      ],
    );
  }

  // نافذة إضافة تعليق جديد
  void _showAddReviewSheet(BuildContext context) {
    int userRating = 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Write a Review", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              // اختيار النجوم
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => setModalState(() => userRating = index + 1),
                    icon: Icon(
                      index < userRating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 35,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 15),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Share your experience...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDDE3FE),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Submit Review"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}