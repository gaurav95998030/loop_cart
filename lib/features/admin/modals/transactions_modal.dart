



import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/client/payment/view_modal/payement_method_provider.dart';

class TransactionsModal{
  String transactionId;
  DateTime date;
  double amount;
  PaymentMethod paymentMethod;
  ProductModal product;
  String userId;
  String adminId;

  TransactionsModal({required this.adminId,required this.paymentMethod,required this.product,required this.date,required this.userId,required this.amount,required this.transactionId});

  Map<String, dynamic> toJson() => {
    'adminId':adminId,
    'transactionId': transactionId,
    'date': date.toIso8601String(), // Convert DateTime to Firestore Timestamp
    'amount': amount,
    'paymentMethod': paymentMethod.name, // Store enum as string
    'product': product.toJson(), // Convert ProductModal to JSON
    'userId': userId,
  };

  factory TransactionsModal.fromJson(Map<String, dynamic> json) {
    return TransactionsModal(
      adminId:json['adminId'],
      transactionId: json['transactionId'] as String,
      date: DateTime.parse(json['date']) , // Convert Firestore Timestamp to DateTime
      amount: (json['amount'] as num).toDouble(), // Convert num to double
      paymentMethod: PaymentMethod.values.firstWhere(
            (e) => e.toString() == json['paymentMethod'],
        orElse: () => PaymentMethod.Cash, // Default value in case of mismatch
      ),
      product: ProductModal.fromJson(json['product'] as Map<String, dynamic>), // Convert JSON to ProductModal
      userId: json['userId'] as String,
    );
  }

}