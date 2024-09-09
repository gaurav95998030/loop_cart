


import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Product"),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Minimize size to fit content
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.image, size: 40.0), // Larger icon for better visibility
                      color: Colors.blueAccent, // Icon color
                    ),
                    SizedBox(height: 8.0), // Space between icon and text
                    Text(
                      "Upload Image",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
             Form(
              key: _formKey,
                child: const Column(
                  children: [

                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
