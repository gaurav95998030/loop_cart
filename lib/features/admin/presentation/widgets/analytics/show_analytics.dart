


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loop_cart/features/admin/services/admin_service.dart';
import 'package:loop_cart/utils/vertical_space.dart';

import '../../../modals/product_modal.dart';
import '../../../modals/transactions_modal.dart';

class ShowAnalytics extends StatefulWidget {
  const ShowAnalytics({super.key});

  @override
  State<ShowAnalytics> createState() => _ShowAnalyticsState();
}

class _ShowAnalyticsState extends State<ShowAnalytics> {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: FirebaseFirestore.instance.collection("transactions").where("adminId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }

        if(snapshot.hasData){
          double total = 0;

          final docs = snapshot.data!.docs;

          for(var item in docs){
            final transData = item.data();
            TransactionsModal trans = TransactionsModal.fromJson(transData);
            total+=trans.amount;
          }
          Map<ProductCategory, double> categoryEarnings = {
            for (var category in ProductCategory.values) category: 0.0,
          };




            for (var item in docs) {
              final docData = item.data();


              String categoryStr = docData['product']['category'];
              ProductCategory? category = ProductCategory.values.firstWhere(
                      (e) => e.name == categoryStr);


              double amount = (docData['amount'] ?? 0).toDouble();

              categoryEarnings[category] = categoryEarnings[category]! + amount;
            }



          final List<double> totalEarnings = ProductCategory.values.map((
              category) {
            final earnings = categoryEarnings[category] ?? 0;
            // Ensure we don't pass NaN or infinity values to the chart
            if (earnings.isNaN || earnings.isInfinite) {
              return 0.0;
            }
            return earnings;
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),

            child: Column(
              children: [
                Text("Total Earning $total",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                const VerticalSpace(height: 10),
                EarningsBarChart(totalEarnings:totalEarnings)

              ],
            ),
          );
        }
        return const Text("No earning");
      },
    );
  }
}


class EarningsBarChart extends StatefulWidget {

final List<double> totalEarnings;
  const EarningsBarChart({required this.totalEarnings,super.key,});

  @override
  State<EarningsBarChart> createState() => _EarningsBarChartState();
}

class _EarningsBarChartState extends State<EarningsBarChart> {
  String getCategoryName(ProductCategory category) {
    switch (category) {
      case ProductCategory.Mobile:
        return 'Mobile';
      case ProductCategory.Laptop:
        return 'Laptop';
      case ProductCategory.Tv:
        return 'TV';
      case ProductCategory.Clothes:
        return 'Clothes';
     // case ProductCategory.Electronics:
        return 'Electronics';
     // case ProductCategory.HomeAppliances:
        return 'Home Appliances';
      case ProductCategory.Books:
        return 'Books';
     // case ProductCategory.Beauty:
        return 'Beauty';
    //  case ProductCategory.Sports:
        return 'Sports';
   //   case ProductCategory.Toys:
    //    return 'Toys';
    //  case ProductCategory.Groceries:
        return 'Groceries';
    //  case ProductCategory.Furniture:
        return 'Furniture';
     // case ProductCategory.Health:
        return 'Health';
      default:
        return 'Unknown';
    }
  }


  @override




  @override
  Widget build(BuildContext context) {
    // Convert the map to a list of earnings, ensuring no invalid values



          return Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles:AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false
                    )
                  ) ,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        return Text(
                          getCategoryName(
                              ProductCategory.values[value.toInt()]),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 35,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      getTitlesWidget: (value, _) {
                        return Text(
                          value.toString(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 10),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: widget.totalEarnings
                    .asMap()
                    .entries
                    .map((entry) =>
                    BarChartGroupData(
                      x: entry.key, // index of the category
                      barRods: [
                        BarChartRodData(
                          toY: entry.value, // Total earnings for this category
                          color: Colors.blueAccent,
                          width: 40,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ))
                    .toList(),
              ),
            ),
          );




  }
}
