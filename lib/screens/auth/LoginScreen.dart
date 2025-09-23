import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/WooCommerceService.dart';
import '../HomePage.dart';
import 'RegisterScreen.dart'; // 👈 import RegisterScreen

class LoginScreen extends StatefulWidget {
  final String title;

  const LoginScreen({super.key, required this.title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool loading = false;
  String message = "";

  @override
  void initState() {
    super.initState();
    _username.text = "rmanandmr05@gmail.com";
    _password.text = "password";
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final service = WooCommerceService();

    try {
      final response = await service.loginUser(
        _username.text.trim(),
        _password.text.trim(),
      );

      if (response.containsKey("token")) {
        setState(() => message = "Login Successful");

        String email = response["user_email"];

        // 🔹 Fetch WooCommerce customer by email
        final customer = await service.getCustomerByEmail(email);

        print("Customer ID: ${customer["id"]}");
        print("Customer Name: ${customer["first_name"]} ${customer["last_name"]}");
        print("Avatar: ${customer["avatar_url"]}");

        // Save token + customer ID
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response["token"]);
        await prefs.setInt("customer_id", customer["id"]);

        // Navigate to home page with drawer
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        setState(() => message = response["message"] ?? "Login Failed");
      }
    } catch (e) {
      setState(() => message = "Error: $e");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false, // 🚫 removes back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _username,
                decoration:
                const InputDecoration(labelText: "Username or Email"),
                validator: (v) => v!.isEmpty ? "Enter username" : null,
              ),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "Enter password" : null,
              ),
              const SizedBox(height: 20),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _login,
                child: const Text("Login"),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 20),
              // 👇 "Don't have an account? Register now" button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const RegisterScreen(title: "Register"),
                    ),
                  );
                },
                child: const Text(
                  "Don’t have an account? Register now",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
