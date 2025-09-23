import 'package:flutter/material.dart';
import '../../services/WooCommerceService.dart';
import 'LoginScreen.dart'; // <-- make sure you have this

class RegisterScreen extends StatefulWidget {
  final String title;

  const RegisterScreen({super.key, required this.title});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool loading = false;
  String message = "";

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final service = WooCommerceService();

    try {
      final response = await service.registerUser({
        "email": _email.text.trim(),
        "username": _username.text.trim(),
        "password": _password.text.trim(),
        "first_name": "",
        "last_name": "",
        "billing": {},
        "shipping": {}
      });

      if (response.containsKey("id")) {
        setState(() => message = "Registration Successful");
      } else {
        setState(() => message = response["message"] ?? "Registration Failed");
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
                controller: _email,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(labelText: "Username"),
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
                onPressed: _register,
                child: const Text("Register"),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              // 👇 Already a customer? Login button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const LoginScreen(title: "Login")),
                  );
                },
                child: const Text(
                  "Already a customer? Login",
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