import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loop_cart/features/admin/view_modal/main_image_provider.dart';
import 'package:loop_cart/utils/show_snackbar.dart';

class UploadMainImage extends StatefulWidget {
  const UploadMainImage({super.key});

  @override
  State<UploadMainImage> createState() => _UploadMainImageState();
}

class _UploadMainImageState extends State<UploadMainImage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        
        MainImageState uploadedImage =ref.watch(mainImageProvider);
        
        return Container(
          width: double.infinity,
          height: 250,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0), // Add padding for better spacing
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.0,
                offset: const Offset(0, 4), // Shadow offset
              ),
            ],
          ),
          child: uploadedImage.pickedImage==null?Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Minimize size to fit content
              children: [

                if(uploadedImage.isLoading)
                  const CircularProgressIndicator(),
                IconButton(
                  onPressed: () async {
                   bool res = await ref.read(mainImageProvider.notifier).uploadImage();
                   if(res){
                     ShowSnackbarMsg.showSnack("Image Uploaded SuccessFully");
                   }else{
                     ShowSnackbarMsg.showSnack("Upload failed Please Try again!!");
                   }
                  },
                  icon: const Icon(Icons.image, size: 40.0), // Larger icon for better visibility
                  color: Colors.blueAccent, // Icon color
                ),
                const SizedBox(height: 8.0), // Space between icon and text
                const Text(
                  "Upload Image",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ):Image.file(File(uploadedImage.pickedImage!.path),fit: BoxFit.cover,),
        );
      }
    );
  }
}
