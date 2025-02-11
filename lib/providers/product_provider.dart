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

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.isLiked = false,
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
    _loadDummyProducts();
    fetchProducts();
  }

  void _loadDummyProducts() {
    _dummyProducts = [
      Product(
        id: 'dummy1',
        name: 'Dummy Product 1',
        imageUrl: 'https://via.placeholder.com/150',
        price: 99.99,
      ),
      Product(
        id: 'dummy2',
        name: 'Dummy Product 2',
        imageUrl: 'https://via.placeholder.com/150',
        price: 89.99,
      ),
      // Add more dummy products as needed
    ];
  }

  Future<void> fetchProducts() async {
    if (_isLoading || !_hasMore || _hasFetched) return;
    _isLoading = true;
    notifyListeners();

    try {
      // Replace with your API endpoint

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

      // Insert dummy products after every 7th product
      if ((i + 1) % 7 == 0 && _dummyProducts.isNotEmpty) {
        combinedProducts.add(_dummyProducts[dummyIndex % _dummyProducts.length]);
        dummyIndex++;
      }
    }

    return combinedProducts;
  }
}