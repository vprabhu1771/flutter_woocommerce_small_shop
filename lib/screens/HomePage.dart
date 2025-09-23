import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/CustomDrawer.dart';
import 'BrandScreen.dart';
import 'CategoryScreen.dart';
import 'HomeScreen.dart';
import 'ProductScreen.dart';
import 'auth/LoginScreen.dart';
import 'auth/ProfileScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Page titles for AppBar
  final List<String> _titles = [
    "Home",
    "Category",
    "Brand",
    "Products",
    "My Profile",
  ];

  // Pages without AppBars
  final List<Widget> _pages = const [
    HomeScreen(title: 'Home'),
    CategoryScreen(title: 'Category'),
    BrandScreen(title: 'Brand'),
    ProductScreen(title: 'Products'),
    ProfileScreen(title: 'My Profile'),
  ];

  void _onDrawerItemSelected(int index) async {
    if (index == 5) {
      // Logout selected
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const LoginScreen(title: 'Login')),
        );
      }
      return;
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), // ✅ Dynamic title
      ),
      drawer: CustomDrawer(onItemSelected: _onDrawerItemSelected),
      body: _pages[_selectedIndex],
    );
  }
}
