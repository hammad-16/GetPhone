import 'dart:async';

import 'package:flutter/material.dart';

class BannerProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int totalBanners = 5;

  int get currentPage => _currentPage;

  void updatePage(int page) {
    // Handle infinite scrolling
    if (page >= totalBanners) {
      _currentPage = 0;
      // Jump to first page without animation
      pageController.jumpToPage(0);
    } else if (page < 0) {
      _currentPage = totalBanners - 1;
      // Jump to last page without animation
      pageController.jumpToPage(totalBanners - 1);
    } else {
      _currentPage = page;
    }
    notifyListeners();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (pageController.hasClients) {
        final nextPage = _currentPage + 1;
        if (nextPage >= totalBanners) {
          // Jump to first page without animation when reaching the end
          pageController.jumpToPage(0);
        } else {
          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}