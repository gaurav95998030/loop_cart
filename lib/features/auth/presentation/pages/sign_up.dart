
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/auth/presentation/pages/login_page.dart';
import 'package:loop_cart/features/auth/view_modal/form_state_provider.dart';
import 'package:loop_cart/features/auth/view_modal/loader_provider/signup_user_loader_provider.dart';
import 'package:loop_cart/utils/show_snackbar.dart';
import 'package:loop_cart/utils/vertical_space.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _signUpFormKey = GlobalKey<FormState>();
  String enteredUsername = '';
  String enteredEmail = '';
  String enteredPassword = '';

  void handleSubmitClick(WidgetRef ref) async{
   bool res= _signUpFormKey.currentState!.validate();
   if(res){
     _signUpFormKey.currentState!.save();
     String res = await ref.read(formStateProvider.notifier).handleCreateAccountSubmit(email: enteredEmail, password: enteredPassword, userName: enteredUsername);
     if(res=="success"){
      ShowSnackbarMsg.showSnack("SignUp In Successfully");
      _signUpFormKey.currentState!.reset();
      if (!mounted) return;  // If not mounted, return early

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const LoginPage()));
     }else{
       ShowSnackbarMsg.showSnack(res);
     }

   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Account",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,  // Adds some spacing to the letters
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal.shade700,  // Darken the primary color for a more premium look
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset("assets/create_page_shop.jpg"),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),  // Increase padding for a spacious feel
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VerticalSpace(height: 20),
                     Text(
                      "Welcome to LoopCart",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade900,  // Darken text for better contrast
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpace(height: 20),
                    Card(
                      elevation: 8,  // Increase elevation for a more pronounced shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),  // Soften corners for a modern look
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),  // Add more padding for spacing
                        child: Consumer(
                          builder: (context, ref, child) {
                            return Form(
                              key: _signUpFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    validator: (userName) {
                                      return ref.read(formStateProvider.notifier).validUserName(userName ?? '');
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Username",
                                      prefixIcon: const Icon(Icons.person, color: Colors.teal),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),  // More rounded corners
                                      ),
                                    ),
                                    onSaved: (userName) {
                                      enteredUsername = userName!;
                                    },
                                  ),
                                  const VerticalSpace(height: 16),
                                  TextFormField(
                                    validator: (email) {
                                      return ref.read(formStateProvider.notifier).validateEmail(email ?? '');
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      prefixIcon: const Icon(Icons.email, color: Colors.teal),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onSaved: (email) {
                                      enteredEmail = email!;
                                    },
                                  ),
                                  const VerticalSpace(height: 16),
                                  TextFormField(
                                    validator: (pass) {
                                      return ref.read(formStateProvider.notifier).validatePass(pass ?? '');
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      prefixIcon: const Icon(Icons.lock, color: Colors.teal),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onSaved: (pass) {
                                      enteredPassword = pass!;
                                    },
                                  ),
                                  const VerticalSpace(height: 24),
                                  ElevatedButton(
                                    onPressed: () {
                                      handleSubmitClick(ref);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal.shade700,  // Darker teal for button
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Consumer(
                                      builder: (context, ref, child) {
                                        bool isLoading = ref.watch(signUpUserLoaderProvider);
                                        return Text(
                                          isLoading ? "Please Wait..." : "Create Account",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 20),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,  // Softened text color
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const LoginPage()));
                            },
                            child:  Text(
                              "Sign in",
                              style: TextStyle(

                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,  // Lighter accent color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
