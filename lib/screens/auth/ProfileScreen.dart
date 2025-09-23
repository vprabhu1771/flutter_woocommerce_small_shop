import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/WooCommerceService.dart';

class ProfileScreen extends StatefulWidget {
  final String title;

  const ProfileScreen({super.key, required this.title});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _customer;
  bool _loading = true;
  String _error = "";

  @override
  void initState() {
    super.initState();
    _loadCustomer();
  }

  Future<void> _loadCustomer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt("customer_id");

      if (customerId == null) {
        setState(() {
          _error = "No customer ID found. Please log in again.";
          _loading = false;
        });
        return;
      }

      final service = WooCommerceService();
      final customer = await service.getCustomerById(customerId);

      setState(() {
        _customer = customer;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load profile: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(child: Text(_error, style: const TextStyle(color: Colors.red)));
    }

    final avatarUrl = (_customer?["avatar_url"] ?? "") as String;
    final firstName = (_customer?["first_name"] ?? "") as String;
    final lastName = (_customer?["last_name"] ?? "") as String;
    final email = (_customer?["email"] ?? "") as String;

    final billing = _customer?["billing"] ?? {};
    final address = (billing["address_1"] ?? "") as String;
    final city = (billing["city"] ?? "") as String;
    final phone = (billing["phone"] ?? "") as String;

    return Scaffold(
      // appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : const AssetImage("assets/images/default_avatar.png")
              as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              "$firstName $lastName",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(email.isNotEmpty ? email : "No email provided"),
            const SizedBox(height: 16),
            Text("Billing Address: $address, $city"),
            Text("Phone: ${phone.isNotEmpty ? phone : "N/A"}"),
          ],
        ),
      ),
    );
  }
}
