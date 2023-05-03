import 'package:flutter/material.dart';
import 'package:whatsapp/core/res/colors.dart';

class WhatButton extends StatelessWidget {
  const WhatButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: tabColor,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
