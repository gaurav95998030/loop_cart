import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  final double height;
  const VerticalSpace({required this.height,super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: height,
    );
  }
}
