

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loop_cart/features/admin/presentation/pages/admin_home_page.dart';
import 'package:loop_cart/features/client/presentation/pages/client_home_page.dart';
import 'package:loop_cart/utils/common_widgets/screen_loader.dart';

import 'utils/methods/decide_client_or_admin.dart';

class HomePage extends StatefulWidget {
 final User user;

  const HomePage({required this.user,super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  Widget content =const ScreenLoader() ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPage();

  }


  Future<void> loadPage() async{
    bool iAdmin = await isAdmin(widget.user);

    if(iAdmin){
      setState(() {
        isLoading = false;
        content = const AdminHomePage();
      });
    } else{
      setState(() {
        isLoading = false;
        content = const ClientHomePage();
      });
    }

  }

  @override
  Widget build(BuildContext context) {


    if(isLoading){
      const ScreenLoader();
    }


    return content;
  }
}
