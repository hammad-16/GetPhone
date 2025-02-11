import 'package:flutter/material.dart';

Widget buildIconButton(String imagePath, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.network(
          imagePath,
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image); // Fallback for broken images
          },
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    ),
  );
}