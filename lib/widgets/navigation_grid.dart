import 'package:flutter/material.dart';

class NavigationGrid extends StatelessWidget {
  const NavigationGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> buttons = [
      {'label': 'How to Buy', 'imagePath': 'assets/images/howToBuy.png'},
      {'label': 'How to Sell', 'imagePath': 'assets/images/howToSell.png'},
      {'label': 'Oru Guide', 'imagePath': 'assets/images/oruGuide.png'},
      {'label': 'About Us', 'imagePath': 'assets/images/aboutUs'},
      {'label': 'Privacy Policy', 'imagePath': 'assets/images/privacyPolicy.png'},
      {'label': 'FAQs', 'imagePath': 'assets/images/faqIm.png'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {

          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  buttons[index]['imagePath']!,
                  width: 90,
                  height: 90,
                ),
                const SizedBox(height: 8),

              ],
            ),
          ),
        );
      },
    );
  }
}