import 'package:flutter/material.dart';
import '../services/WooCommerceService.dart';


class ProductScreen extends StatefulWidget {

  final String title;

  const ProductScreen({super.key, required this.title});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final WooCommerceService _wooService = WooCommerceService();
  List<dynamic> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final data = await _wooService.getProducts();
      setState(() {
        _products = data;
        _loading = false;
      });
    } catch (e) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("WooCommerce Products")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];

          // print(product["images"][0]["src"]);
          return ListTile(
            leading: product["images"] != null && product["images"].isNotEmpty
                ? Image.network(fixImageUrl(product["images"][0]["src"]), width: 50, height: 50)
                : const Icon(Icons.shopping_bag),
            title: Text(product["name"] ?? "No name"),
            subtitle: Text("₹${product["price"] ?? "0"}"),
          );
        },
      ),
    );
  }
}
