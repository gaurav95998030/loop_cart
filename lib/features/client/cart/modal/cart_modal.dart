

class CartModal {
  String userId;
  String cartId;
  String productId;
  int quantity;
  String productTitle;
  String mainImage;
  double price;
  String adminId;


  CartModal({

    required this.adminId,
    required this.price,
    required  this.productTitle,
    required this.mainImage,
    required this.userId,
    required this.productId,
    required this.cartId,
    required this.quantity,
  });

  // Convert an instance of CartModal to JSON
  Map<String, dynamic> toJson() {
    return {
      'adminId':adminId,
      'price':price,
      'mainImage':mainImage,
      'productTitle':productTitle,
      'userId': userId,
      'cartId': cartId,
      'productId': productId,
      'quantity': quantity,
    };
  }

  // Create an instance of CartModal from JSON
  factory CartModal.fromJson(Map<String, dynamic> json) {
    return CartModal(
      adminId: json['adminId'],
      price: json['price'].toDouble(),
      mainImage: json['mainImage'],
      productTitle:json['productTitle'],
      userId: json['userId'],
      cartId: json['cartId'],
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }
}
