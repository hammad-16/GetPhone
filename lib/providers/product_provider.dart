// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  bool isLiked;
  final String city;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.isLiked = false,
    required this.city
  });
}

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _dummyProducts = [];
  bool _isLoading = false;
  int _page = 1;
  bool _hasMore = true;
  bool _hasFetched = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  ProductProvider() {

    fetchProducts();
  }



  Future<void> fetchProducts() async {
    if (_isLoading || !_hasMore || _hasFetched) return;
    _isLoading = true;
    notifyListeners();

    try {

// API Endpoint
      final response = await http.post(
        Uri.parse('http://40.90.224.241:5000/filter'),
        headers: {
          'Content-Type': 'application/json',
        },
        // The filter field expects an object, so we pass an empty object
        body: jsonEncode({
          'filter': {},
        }),
      );

      if (response.statusCode == 200) {

        dynamic data = json.decode(response.body);
        data = data["data"]["data"];
        List<dynamic> newProducts = data.map((item) {

          return Product(
            id: item['_id'].toString(),
            name: item['marketingName'],
            imageUrl: item['imagePath'],
            price: double.parse(item['listingPrice']),
            city: item['listingLocation']
          );
        }).toList();
        print("testing this");
        List<Product> testing = newProducts.cast<Product>();
        _products.addAll(testing);
        _page++;
        _hasMore = newProducts.isNotEmpty; // Stop pagination if no more products
        _hasFetched = true;
      } else {
        print(response.statusCode);
        print(response.body);
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleLike(String productId) {
    final product = _products.firstWhere((p) => p.id == productId);
    product.isLiked = !product.isLiked;
    notifyListeners();
  }

  // Get the list of products with dummy products inserted cyclically
  List<Product> getProductsWithDummies() {
    List<Product> combinedProducts = [];
    int dummyIndex = 0;

    for (int i = 0; i < _products.length; i++) {
      combinedProducts.add(_products[i]);


    }

    return combinedProducts;
  }
}