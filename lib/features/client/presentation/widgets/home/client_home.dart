




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop_cart/features/client/presentation/widgets/home/carousel_options.dart';
import 'package:loop_cart/features/client/presentation/widgets/home/deal_of_the_day.dart';
import 'package:loop_cart/features/client/presentation/widgets/home/search_bar.dart';
import 'package:loop_cart/features/client/presentation/widgets/home/see_all_deals.dart';
import 'package:loop_cart/features/client/presentation/widgets/home/top_categories.dart';
import 'package:loop_cart/utils/vertical_space.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {

  TextEditingController queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  SingleChildScrollView(
        child: Column(

          children: [
            VerticalSpace(height: 10),
            SearchBarHome(),
            TopCategories(),
            CarouselOptions(),
            DealOfTheDay(),
            SeeAllDeals(),
            Container(
              width: double.infinity,
              height: 300,
            )
          ],
        ),
      ),
    );
  }
}
