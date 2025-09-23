import 'dart:async';
import 'package:flutter/material.dart';
import '../services/WooCommerceService.dart';

class BrandScreen extends StatefulWidget {
  final String title;

  const BrandScreen({super.key, required this.title});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  final WooCommerceService _wooService = WooCommerceService();

  List<dynamic> _brands = [];
  bool _loading = true;

  Timer? _timer; // keep a reference to the timer

  @override
  void initState() {
    super.initState();

    // Run immediately once
    _loadBrands();

    // Run every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _loadBrands();
    });
  }

  Future<void> _loadBrands() async {
    try {
      final data = await _wooService.getBrands();

      if (!mounted) return; // prevent setState after dispose

      setState(() {
        _brands = data;
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
    _timer?.cancel(); // cancel timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(widget.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadBrands,
        child: ListView.builder(
          itemCount: _brands.length,
          itemBuilder: (context, index) {
            final brand = _brands[index];

            return ListTile(
              leading: brand["image"] != null
                  ? Image.network(
                fixImageUrl(brand["image"]["src"]),
                width: 50,
                height: 50,
              )
                  : const Icon(Icons.shopping_bag),
              title: Text(brand["name"] ?? "No name"),
            );
          },
        ),
      ),
    );
  }
}
