


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/admin/presentation/widgets/add_new_prod/upload_featured_images.dart';
import 'package:loop_cart/features/admin/presentation/widgets/add_new_prod/upload_main_image.dart';
import 'package:loop_cart/features/admin/view_modal/features_images_provider.dart';
import 'package:loop_cart/features/admin/view_modal/loader/add_product_loader.dart';
import 'package:loop_cart/features/admin/view_modal/main_image_provider.dart';
import 'package:loop_cart/features/admin/view_modal/product_provider.dart';
import 'package:loop_cart/features/admin/view_modal/tab_index_provider.dart';
import 'package:loop_cart/utils/show_snackbar.dart';
import 'package:loop_cart/utils/vertical_space.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
 ProductCategory _selectedCategory = ProductCategory.Books;
 String enteredTitle = '';
 String enteredDiscription = '';
 double amount = 0;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Product"),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               const UploadMainImage(),
               const UploadFeaturedImages(),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const VerticalSpace(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Product Title",
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product title';
                    }
                    return null;
                  },
                  onSaved: (vale){
                    enteredTitle=vale!;
                  },
                ),
                const VerticalSpace(height: 16),
                TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Description",
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (des){
                    enteredDiscription = des!;
                  },
                ),
                const VerticalSpace(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                  onSaved: (am){
                    amount = double.tryParse(am!)!;
                  },
                ),
                const VerticalSpace(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Category: ", style: TextStyle(fontSize: 16)),

                    Expanded(
                      child: DropdownButtonFormField<ProductCategory>(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        value: _selectedCategory,
                        items: ProductCategory.values.map((category) {
                          return DropdownMenuItem<ProductCategory>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const VerticalSpace(height: 24),
                Center(
                  child: Consumer(
                    builder: (context,ref,child) {
                      return ElevatedButton(
                        onPressed: () async {

                          if(ref.read(mainImageProvider).pickedImage==null){
                            ShowSnackbarMsg.showSnack("Please Upload Product Image first");
                            return ;
                          }
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                           bool res = await ref.read(productsProvider.notifier).addProduct(title: enteredTitle, description: enteredDiscription, price: amount, category: _selectedCategory);

                           if(res){
                             _formKey.currentState!.reset();
                             ShowSnackbarMsg.showSnack("Added Successfully");
                             ref.read(tabIndexProvider.notifier).update((cb)=>0);
                             ref.invalidate(featuresImagesProvider);
                             ref.invalidate(mainImageProvider);
                           }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Consumer(
                          builder: (context,ref,child) {
                            bool isLoading = ref.watch(addProductLoaderProvider);
                            return  Text(
                              isLoading?"Adding":"Add Product",
                              style: const TextStyle(fontSize: 18),
                            );
                          }
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          )
            ],
          ),
        ),
      ),
    );
  }
}
