import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/faq.dart';
import 'package:http/http.dart' as http;
class FAQProvider extends ChangeNotifier {
  List<FAQ> faqs = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<FAQ> get _faqs => faqs;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch FAQs from the API
  Future<void> fetchFAQs() async {


    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
          Uri.parse('https://example.com/api/faqs')
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> faqData = data['dataObject'];

        List<FAQ> newFaqs = faqData.map((item) {
          return FAQ(
            question: item['question'] ?? '',
            answer: item['answer'] ?? '',
          );
        }).toList();

        faqs = newFaqs;
        _errorMessage = '';
      } else {
        _errorMessage = 'Failed to load FAQs: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}