import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselOptions extends StatefulWidget {

  const CarouselOptions({super.key});

  @override
  State<CarouselOptions> createState() => _CarouselOptionsState();
}

class _CarouselOptionsState extends State<CarouselOptions> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    String  base = "assets/images/crousel";

    List<String> crouselImages = [
      "$base/c1.jpg",
      "$base/c2.jpg",
      "$base/c3.jpg",
      "$base/c4.jpg",
    ];
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: crouselImages.length, // Simplified the itemCount
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.all(8),
                  child: Image.asset( crouselImages[index],fit: BoxFit.cover,),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (controller.page! > 0) {
                    controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                icon: const Icon(Icons.keyboard_arrow_left_sharp),
              ),
              SmoothPageIndicator(
                controller: controller, // PageController
                count: 4, // Match with the itemCount
                effect: const WormEffect(), // your preferred effect
                onDotClicked: (index) {
                  controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  if (controller.page! < 3) {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                icon: const Icon(Icons.keyboard_arrow_right_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
