



import 'package:flutter/material.dart';

class UserOptions extends StatefulWidget {
  const UserOptions({super.key});

  @override
  State<UserOptions> createState() => _UserOptionsState();
}


 List<String> options = ["Logout","Your Orders","Your WishList","Turn Seller"];
class _UserOptionsState extends State<UserOptions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStyledButton(
                context,
                icon: Icons.logout,
                label: "Log out",
                onPressed: () {
                  // Add log out functionality
                },
              ),
              _buildStyledButton(
                context,
                icon: Icons.shopping_bag,
                label: "Your Orders",
                onPressed: () {
                  // Navigate to orders page
                },
              ),
            ],
          ),
          const SizedBox(height: 16), // Space between rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStyledButton(
                context,
                icon: Icons.favorite,
                label: "Your Wishlists",
                onPressed: () {
                  // Navigate to wishlist
                },
              ),
              _buildStyledButton(
                context,
                icon: Icons.store,
                label: "Turn Seller",
                onPressed: () {
                  // Turn seller action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStyledButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(140, 50),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          backgroundColor: Colors.teal.shade100,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),

        ),
      ),
    );
  }
}
