import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ColorText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight; // Add this parameter

  const ColorText({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.fontWeight = FontWeight
        .normal, // Set a default font weight or provide it during construction
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 6),
      baseColor: Colors.purple,
      highlightColor: Colors.red,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight, // Use the provided font weight
        ),
      ),
    );
  }
}
