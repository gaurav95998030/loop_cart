





import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loop_cart/features/auth/presentation/pages/login_page.dart';

class GreetClient extends StatelessWidget {
  const GreetClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(12),

        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(
                Icons.person,
                color: Colors.teal,
                size: 30,
              ),
              const SizedBox(width: 10),
              RichText(
                text: TextSpan(
                  text: "Hello, ",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: FirebaseAuth.instance.currentUser?.displayName?.toUpperCase() ?? "User",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(onPressed: () async{
               await FirebaseAuth.instance.signOut();

               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>LoginPage()));

              }, child: const Text("Log out"))
            ],
          ),
        ),
      ),
    );
  }
}
