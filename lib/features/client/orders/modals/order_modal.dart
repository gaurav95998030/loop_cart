




import 'package:loop_cart/features/admin/modals/product_modal.dart';


import '../../cart/modal/cart_modal.dart';


enum OrderStatus  {Pending,Shipped,Delivered,Revieved,Completed}

class OrderModal {
  String orderId;
  String userId;
  DateTime date;
  CartModal product;
  OrderStatus status;
  String adminId;
  String productId;

  OrderModal({
    required this.productId,
    required this.adminId,
    required this.orderId,
    required this.userId,
    required this.date,
    required this.product,
    required this.status,
  });


  Map<String, dynamic> toJson() => {
    'productId':productId,
    'orderId':orderId,
    'adminId':adminId,
    'date': date.toIso8601String(),
    'product': product.toJson(),
    'status': status.name,
    'userId':userId,
  };


  factory OrderModal.fromJson(Map<String, dynamic> json) => OrderModal(
    productId: json['productId'],
    adminId:json['adminId'],
    orderId: json['orderId'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
    product: CartModal.fromJson(json['product']),
    status: OrderStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
    ),
  );
}