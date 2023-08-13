import 'package:flutter/material.dart';

class Code extends StatelessWidget {
  const Code({super.key, required this.colorOpacity, required this.border});

  final double colorOpacity;
  final String border;

  @override
  Widget build(BuildContext context) {
    return Text(
      "ClipRRect(\n  borderRadius: BorderRadius.circular(12),\n  clipBehavior: Clip.antiAlias,\n  child: BackdropFilter(\n  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),\n  child: Container(\n    height: double.infinity,\n    width: double.infinity,\n    decoration: BoxDecoration(\n      borderRadius: BorderRadius.circular(12),\n      border: $border,\n      gradient: LinearGradient(\n        colors: [\n          Colors.grey.shade300.withOpacity($colorOpacity),\n          Colors.white.withOpacity($colorOpacity),\n        ],\n        begin: Alignment.topLeft,\n        end: Alignment.bottomRight,\n      ),\n      image: use image of noise texture here for the frosted effect\n    ),\n  ),\n ),\n)",
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
