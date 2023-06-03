import 'package:flutter/material.dart';

class NormalMessageCard extends StatelessWidget {
  const NormalMessageCard({
    required this.colour,
    required this.child,
    required this.padding,
    super.key,
  });

  final Widget child;
  final Color colour;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: colour,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: child,
      ),
    );
  }
}
