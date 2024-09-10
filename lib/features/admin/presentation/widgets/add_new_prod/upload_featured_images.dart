import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loop_cart/features/admin/view_modal/features_images_provider.dart';

class UploadFeaturedImages extends StatefulWidget {
  const UploadFeaturedImages({super.key});

  @override
  State<UploadFeaturedImages> createState() => _UploadFeaturedImagesState();
}

class _UploadFeaturedImagesState extends State<UploadFeaturedImages> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        FeaturedImagesState images = ref.watch(featuresImagesProvider);

        return SizedBox(
          width: double.infinity,
          height: 200, // Adjusted height for better layout
          child: Column(
            children: [

              images.images.isEmpty
                  ? Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(featuresImagesProvider.notifier).uploadImage();
                  },
                  icon: const Icon(Icons.upload, size: 20),
                  label: const Text("Upload Featured Images"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ) : Expanded(  // Use Expanded here to give ListView a defined height within the Column
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(images.images[index]!.path), // Changed to non-nullable access
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),

              ),
              if (images.isLoading)
                const CircularProgressIndicator(),
            ],
          ),
        );
      },
    );

  }
}
