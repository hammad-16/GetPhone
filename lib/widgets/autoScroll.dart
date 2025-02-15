import 'dart:async';

import 'package:flutter/material.dart';

class AutoScrollImages extends StatefulWidget {
  const AutoScrollImages({super.key});

  @override
  AutoScrollImagesState createState() => AutoScrollImagesState();
}

class AutoScrollImagesState extends State<AutoScrollImages> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 2) { // Change this number based on total pages
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust height as needed
      child: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
          _timer?.cancel(); // Reset timer on manual swipe
          _startAutoScroll();
        },
        children: [
          Image.network('https://via.placeholder.com/400x200?text=Banner+1', fit: BoxFit.cover),
          Image.network('https://via.placeholder.com/400x200?text=Banner+2', fit: BoxFit.cover),
          Image.network('https://via.placeholder.com/400x200?text=Banner+3', fit: BoxFit.cover),
        ],
      ),
    );
  }
}