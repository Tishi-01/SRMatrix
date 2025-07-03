// widgets/app_background.dart
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'), // Replace with your image
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea( // Optional but helps avoid notch overlaps
        child: child,
      ),
    );
  }
}