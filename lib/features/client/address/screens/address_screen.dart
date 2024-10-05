import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/auth/services/auth_service.dart';
import 'package:loop_cart/features/auth/services/user_service.dart';
import 'package:loop_cart/features/client/cart/view_modal/cart_provider.dart';

import 'package:loop_cart/utils/show_snackbar.dart';
import 'package:loop_cart/utils/vertical_space.dart';


import '../../cart/modal/cart_modal.dart';

import '../../orders/view_modal/add_order_loader.dart';
import '../../orders/view_modal/orders_provider.dart';
import '../../payment/view_modal/payement_method_provider.dart';



class AddressScreen extends StatefulWidget {
  final List<CartModal> carts;
  const AddressScreen({required this.carts,super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  String enteredFlatHouse = '';
  String enteredStreetAndArea = '';
  String enteredPinCode = '';
  String enteredTownAndCity = '';
  String mobileNumber ='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          title: SizedBox(
            width: 120, // Set desired width
            height: 120, // Set desired height
            child: Image.asset(
              "assets/images/loop_cart_logo.png",
              fit: BoxFit.contain, // Ensure the image fits within the box
            ),
          ),
          backgroundColor: Colors.blueAccent, // Stylish background for the AppBar
          centerTitle: true, // Centers the title
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").where('userId',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context,snapshot) {

              final addressData = snapshot.data?.docs.first.data() ;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (addressData?['address'] != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0), // Add padding around the text
                      margin: const EdgeInsets.symmetric(vertical: 10.0), // Add some space around the container
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1), // Light blue background color for emphasis
                        borderRadius: BorderRadius.circular(10), // Rounded corners for a modern look
                        border: Border.all(color: Colors.blueAccent, width: 2), // Stylish border
                      ),
                      child: Text(
                        addressData?['address'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500, // Slightly bold for readability
                          color: Colors.black87, // Dark text for contrast
                        ),
                      ),
                    ),

                  const VerticalSpace(height: 10),
                  const Text(
                    "Enter your Address",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // Stylish text color
                    ),
                  ),
                  const SizedBox(height: 20), // Adds space between the title and form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextFormField(
                          label: 'Mobile Number',
                          hintText: 'Enter Enter Mobile Number',
                          onSaved: (value) {
                            mobileNumber = value!;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                          label: 'Flat, House No.',
                          hintText: 'Enter flat or house number',
                          onSaved: (value) {
                            enteredFlatHouse = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                          label: 'Street and Area',
                          hintText: 'Enter street and area',
                          onSaved: (value) {
                            enteredStreetAndArea = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                          label: 'Pin Code',
                          hintText: 'Enter pin code',
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            enteredPinCode = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                          label: 'Town and City',
                          hintText: 'Enter town or city',
                          onSaved: (value) {
                            enteredTownAndCity = value!;
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              UserService.updateAddress("$enteredFlatHouse $enteredStreetAndArea $enteredPinCode $enteredTownAndCity",mobileNumber);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Select Address',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  SizedBox(width: double.infinity*0.7,
                      child: ElevatedButton(onPressed: (){

                        if(addressData?['address'] == null || addressData?['phoneNumber']==null){
                          ShowSnackbarMsg.showSnack("Please Add the address and phone number first first");
                          return;
                        }
                        _showPaymentDialog(widget.carts);
                      }, child: const Text("Place Order")))

                ],
              );
            }
          ),
        ),
      ),
    );
  }

  // Custom method to build styled TextFormFields
  Widget _buildTextFormField({
    required String label,
    required String hintText,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200], // Light background for better UX
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }


  double _total(List<CartModal> carts){
    double sum=0;
    for(var item in carts){
      sum+=item.price;
    }
    return sum;
  }

  void _showPaymentDialog(List<CartModal> carts) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6, // Adjust height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment Method Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Payment Method",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {

                      PaymentMethod method = ref.watch(paymentMethodProvider);

                      return DropdownButton<PaymentMethod>(
                        value: method,
                        style: const TextStyle(color: Colors.black),
                        dropdownColor: Colors.white,
                        items: PaymentMethod.values
                            .map((met) => DropdownMenuItem(
                          value: met,
                          child: Text(met.name),
                        ))
                            .toList(),
                        onChanged: (value) {
                          ref.read(paymentMethodProvider.notifier).update((_) => value!);
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Horizontal Cart List
             Row(
               children: [
                 Text("Total :" ,style: TextStyle(fontWeight: FontWeight.bold),),
                 Text("${_total(carts).toString()} Rs."),

               ],
             ),
              const VerticalSpace(height: 10),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: carts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: carts[index].mainImage,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            carts[index].productTitle,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\$${carts[index].price.toString()}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),
              // Cancel and Proceed Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red, textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 20),
                  Consumer(
                    builder: (context,ref,child) {
                      return ElevatedButton(


                        onPressed: () {
                          ref.read(ordersProvider.notifier).addToOrders(carts,context,);
                          ref.read(cartProvider.notifier).deleteCartAfterPurchase(carts);

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child:  Consumer(
                          builder: (context,ref,child) {
                            bool isLoading = ref.watch(addOrderLoader);
                            return Text(isLoading?"Please wait":"Proceed");
                          }
                        ),
                      );
                    }
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}
