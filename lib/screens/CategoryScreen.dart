import 'dart:async';
import 'package:flutter/material.dart';
import '../services/WooCommerceService.dart';

class CategoryScreen extends StatefulWidget {
  final String title;

  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final WooCommerceService _wooService = WooCommerceService();
  List<dynamic> _categories = [];
  bool _loading = true;

  Timer? _timer; // keep a reference to the timer

  @override
  void initState() {
    super.initState();

    // Run immediately once
    _loadCategories();

    // Run every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _loadCategories();
    });
  }

  Future<void> _loadCategories() async {
    try {
      final data = await _wooService.getCategories();

      if (!mounted) return; // prevent calling setState on disposed widget

      setState(() {
        _categories = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
      debugPrint("Error: $e");
    }
  }

  String fixImageUrl(String url) {
    return url.replaceFirst("https://localhost", "http://192.168.1.98");
  }

  @override
  void dispose() {
    _timer?.cancel(); // stop timer to prevent memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(widget.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadCategories,
        child: ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return ListTile(
              leading: category["image"] != null
                  ? Image.network(
                fixImageUrl(category["image"]["src"]),
                width: 50,
                height: 50,
              )
                  : const Icon(Icons.shopping_bag),
              title: Text(category["name"] ?? "No name"),
            );
          },
        ),
      ),
    );
  }
}
