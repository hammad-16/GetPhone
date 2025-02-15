import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/brand.dart';
class BrandProvider extends ChangeNotifier{
  List <Brand> _brands = [];
  bool _isLoading = false;

  List<Brand> get brands => _brands;
  bool get isLoading => _isLoading;

  BrandProvider()
  {
    fetchBrands();
  }

  Future<void> fetchBrands() async
  {
    if(_isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {

      final response = await http.get(
        Uri.parse("http://40.90.224.241:5000/makeWithImages")
      );

      if(response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> brandData = data['dataObject'];

        List<Brand> newBrands = brandData.map((item) {
          return Brand(
            make: item['make'],
            imagePath: item['imagePath'],
          );
        }).toList();

        _brands = newBrands;
      }
      else {
        print(response.statusCode);
        print(response.body);
        throw Exception("Failed to load branch");
      }

    }
    catch(e) {
      print("Error fetching brands: $e");
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}



