import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WooCommerceService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? "";
  final String consumerKey = dotenv.env['CONSUMER_KEY'] ?? "";
  final String consumerSecret = dotenv.env['CONSUMER_SECRET'] ?? "";


  late Dio _dio;

  WooCommerceService() {
    final String basicAuth =
        "Basic ${base64Encode(utf8.encode("$consumerKey:$consumerSecret"))}";

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "Authorization": basicAuth,
          "Content-Type": "application/json",
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  /// Fetch catgories
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _dio.get("/products/categories");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load categories: ${response.data}");
      }
    } on DioError catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }

  /// Fetch brands
  Future<List<dynamic>> getBrands() async {
    try {
      final response = await _dio.get("/products/brands");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load brands: ${response.data}");
      }
    } on DioError catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }

  /// Fetch products
  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get("/products");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load products: ${response.data}");
      }
    } on DioError catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }

  /// Fetch orders
  Future<List<dynamic>> getOrders() async {
    try {
      final response = await _dio.get("/orders");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load orders: ${response.data}");
      }
    } on DioError catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }
}
