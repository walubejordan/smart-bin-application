import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/smartbin_logo.png',
          height: size,
          width: size,
        ),
        const SizedBox(height: 10),
        const Text(
          'SmartBin',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
