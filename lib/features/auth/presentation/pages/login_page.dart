

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/auth/presentation/pages/admin_login.dart';
import 'package:loop_cart/features/auth/presentation/pages/sign_up.dart';
import 'package:loop_cart/features/auth/view_modal/form_state_provider.dart';
import 'package:loop_cart/features/auth/view_modal/loader_provider/login_user_loader_provider.dart';
import 'package:loop_cart/features/auth/view_modal/login_form_state_provider.dart';
import 'package:loop_cart/features/client/presentation/pages/client_home_page.dart';
import 'package:loop_cart/home.dart';
import 'package:loop_cart/utils/show_snackbar.dart';

import '../../../../utils/vertical_space.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _loginUpFormKey = GlobalKey<FormState>();

  String enteredEmail = '';
  String enteredPassword = '';
  void handleLoginClick(WidgetRef ref) async{
    bool res = _loginUpFormKey.currentState!.validate();

    if(res){
      _loginUpFormKey.currentState!.save();
    String res = await  ref.read(loginFormStateProvider.notifier).handleLoginClick(email: enteredEmail, password: enteredPassword);
    if(res=='success'){
      ShowSnackbarMsg.showSnack("Logged in Successfully");

      if(!mounted){
        return;
      }

       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=> HomePage(user:FirebaseAuth.instance.currentUser! )));
    } else{
      ShowSnackbarMsg.showSnack(res);
      }
    }
  }
  @override

    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Log In",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.teal, // Use primary color from your theme
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VerticalSpace(height: 20),
                Consumer(
                  builder: (context,ref,child) {
                    UserFormState userDate = ref.watch(formStateProvider);
                    return  Text(
                      "Welcome Back ${userDate.userName}",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                ),
                const VerticalSpace(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Consumer(

                      builder: (context,ref,child) {
                        UserFormState userDate = ref.watch(formStateProvider);
                        return Form(
                          key: _loginUpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                validator: (email){
                                  return ref.read(loginFormStateProvider.notifier).validateEmail(email??'');
                                },
                                initialValue:userDate.email,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onSaved: (value){
                                  enteredEmail= value!;
                                },
                              ),
                              const VerticalSpace(height: 16),
                              TextFormField(
                                validator: (pass){
                                  return ref.read(loginFormStateProvider.notifier).validatePass(pass??'');
                                },
                                obscureText: true,
                                initialValue:userDate.password,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onSaved: (value){
                                  enteredPassword=value!;
                                },
                              ),
                              const VerticalSpace(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  handleLoginClick(ref);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal, // Use primary color from your theme
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Consumer(
                                  builder: (context,ref,child) {
                                    bool isLoading = ref.watch(loginUserLoaderProvider);
                                    return  Text(
                                      isLoading?"Please Wait":"Log In",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                ),
                              ),
                              const VerticalSpace(height: 16),
                              TextButton(
                                onPressed: () {

                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.teal, // Use primary color from your theme
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                ),
                const VerticalSpace(height: 20),
                Center(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>SignUp()));
                            },
                            child: const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.teal, // Use primary color from your theme
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>const AdminLogin()));
                        },
                        child: const Text(
                          "admin login ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal, // Use primary color from your theme
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
      );
    }
  }

