


import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ScreenLoader extends StatefulWidget {
  const ScreenLoader({super.key});

  @override
  State<ScreenLoader> createState() => _ScreenLoaderState();
}

class _ScreenLoaderState extends State<ScreenLoader> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child:  Lottie.asset(
        'assets/animation/app_loader.json',
        )
      ),
    );
  }
}
