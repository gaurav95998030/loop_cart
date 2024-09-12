import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../admin/modals/product_modal.dart';

class SearchBarHome extends StatefulWidget {

  const SearchBarHome({super.key});

  @override
  State<SearchBarHome> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarHome> {

  TextEditingController queryController = TextEditingController();
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    queryController.addListener(() {
      setState(() {
        searchQuery = queryController.text.trim();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 8.0),
      child: Container(
        width: double.infinity,
        height: queryController.text.trim().isNotEmpty?300:null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            TextField(
              controller:queryController,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            if(queryController.text.trim().isNotEmpty)
                Flexible(
                child:SearchSuggestions(query: searchQuery),
            )
          ],
        ),
      ),
    );
  }
}


class SearchSuggestions extends StatelessWidget {
  final String query;

  const SearchSuggestions({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('productTitle', isGreaterThanOrEqualTo: query)
          .where('productTitle', isLessThanOrEqualTo: query + '\uf8ff')
          .limit(10) // Limit the number of suggestions
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products found.'));
        }

        final products = snapshot.data!.docs.map((doc) {
          return ProductModal.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return ListTile(
              contentPadding: EdgeInsets.all(16),  // More spacious padding for the ListTile
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),  // Rounded corners for the image
                child: Image.network(
                  product.mainImage,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,  // Ensures the image covers the designated area without distortion
                ),
              ),
              title: Text(
                product.productTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "${product.description.substring(0, 30)}...",  // Short description with ellipsis
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              trailing: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[100],  // Light green background for the price tag
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Rs. ${product.price.toStringAsFixed(2)}',  // Price formatted to two decimals
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          ),
                        ),

                      ],
                    ),
                  ),
                  RatingBarIndicator(
                    rating: product.rating,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20,
                    direction: Axis.horizontal,
                  )
                ],
              ),
            );
          },
        );

      },
        );


  }
}