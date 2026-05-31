import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sweing_app/core/app_localizations.dart';
import 'package:my_sweing_app/core/constants.dart';

class AllReviewsScreen extends StatefulWidget {
  final int? productId;
  const AllReviewsScreen({super.key, this.productId});

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  bool _isLoading = true;
  int? _userId;
  String? _userToken;
  List<Map<String, dynamic>> _reviews = [];

  final Map<String, dynamic> _mockReview = {
    'userName': 'Ronald Richards',
    'createdAt': '2020-09-13T00:00:00',
    'rating': 5,
    'comment': 'Absolutely stunning dress! Perfect fit and quality. Highly recommend!',
    'isMock': true,
  };

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('userToken');
    _userId = prefs.getInt('userId');
    await _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    try {
      if (widget.productId == null) {
        setState(() => _isLoading = false);
        return;
      }
      final response = await http.get(
        Uri.parse('$baseUrl/reviews?productId=${widget.productId}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _reviews = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      debugPrint('Load reviews error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitReview(int rating, String comment) async {
    final loc = AppLocalizations.of(context);
    if (_userId == null || _userToken == null) return;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reviews'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_userToken',
        },
        body: json.encode({
          'userId': _userId,
          'productId': widget.productId,
          'rating': rating,
          'comment': comment,
        }),
      );

      if (!mounted) return;
      final data = json.decode(response.body);

      if (data['status'] == 'already_reviewed') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.t('already_reviewed')),
            backgroundColor: Colors.orange,
          ),
        );
      } else if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.t('review_submitted')),
            backgroundColor: Colors.green,
          ),
        );
        await _loadReviews();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.t('failed_review'))),
      );
    }
  }

  double get _averageRating {
    if (_reviews.isEmpty) return 4.8;
    final total = _reviews.fold<num>(0, (sum, r) => sum + (r['rating'] as num));
    return total / _reviews.length;
  }

  int get _totalCount => _reviews.length + 1;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          loc.t('reviews_title'),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildReviewSummary(loc),
                const Divider(thickness: 1, height: 1),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    itemCount: _reviews.length + 1,
                    separatorBuilder: (_, __) => const Divider(height: 32),
                    itemBuilder: (context, index) {
                      if (index == 0) return _buildReviewItem(_mockReview);
                      return _buildReviewItem(_reviews[index - 1]);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: _userId != null
          ? FloatingActionButton.extended(
              onPressed: () => _showAddReviewSheet(context),
              backgroundColor: const Color(0xFFDDE3FE),
              foregroundColor: Colors.black,
              icon: const Icon(Icons.edit_note),
              label: Text(loc.t('add_review')),
            )
          : null,
    );
  }

  Widget _buildReviewSummary(AppLocalizations loc) {
    final avg = _averageRating;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                avg.toStringAsFixed(1),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star,
                    size: 18,
                    color: i < avg.round() ? Colors.orange : Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text('$_totalCount ${loc.t('reviews_title')}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    final rating = (review['rating'] as num).toInt();
    final name = review['userName'] ?? 'Anonymous';
    final comment = review['comment'] ?? '';
    final dateRaw = review['createdAt'];
    String dateStr = '';
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
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  if (dateStr.isNotEmpty)
                    Text(dateStr, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  Icons.star,
                  size: 14,
                  color: i < rating ? Colors.orange : Colors.grey[300],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(comment, style: const TextStyle(color: Colors.black87, height: 1.4)),
      ],
    );
  }

  void _showAddReviewSheet(BuildContext context) {
    final loc = AppLocalizations.of(context);
    int userRating = 0;
    final reviewController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.t('write_review'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
                controller: reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: loc.t('share_experience'),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (userRating == 0 || reviewController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text(loc.t('select_rating_review')),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    Navigator.pop(ctx);
                    await _submitReview(userRating, reviewController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDDE3FE),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(loc.t('submit_review')),
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
