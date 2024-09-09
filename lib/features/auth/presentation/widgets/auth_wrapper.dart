

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loop_cart/features/auth/presentation/pages/login_page.dart';
import 'package:loop_cart/features/auth/presentation/pages/sign_up.dart';

import '../../../../utils/methods/decide_client_or_admin.dart';
import '../../../../home.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,AsyncSnapshot snapshots) {

          if(snapshots.connectionState==ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          if(snapshots.connectionState==ConnectionState.active){
            User? user = snapshots.data;
            if(user!=null){

              return  HomePage(user: user,);
            }
            return const LoginPage();
          }

          return const LoginPage();
        }
    );
  }
}
