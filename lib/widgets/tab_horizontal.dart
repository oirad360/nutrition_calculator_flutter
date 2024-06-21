import 'package:flutter/material.dart';

class TabHorizontal extends StatelessWidget {
  const TabHorizontal({super.key, required this.icon, required this.text, this.spaceBetween = 5.0});

  final IconData icon;
  final String text;
  final double spaceBetween;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(width: spaceBetween),
          Text(text),
        ],
      ),
    );
  }
}
