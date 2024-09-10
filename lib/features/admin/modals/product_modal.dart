
enum ProductCategory {
  Mobile,
  Laptop,
  Tv,
  Clothes,
  Electronics,
  HomeAppliances,
  Books,
  BeautyAndPersonalCare,
  SportsAndOutdoors,
  ToysAndGames,
  Groceries,
  Furniture,
  HealthAndWellness,
}



class ProductModal {

  String productId;
  String adminId;
  List<String> featureImages;
  double price;
  ProductCategory category;
  DateTime time;
  String mainImage;
  String description;
  String productTitle;
  int buyCount;

  ProductModal({required this.buyCount,required this.price,required this.category,required this.adminId,required this.description,required this.featureImages,required this.mainImage,required this.productId,required this.productTitle,required this.time});

  Map<String, dynamic> toJson() {
    return {
      'buyCount':buyCount,
      'productId': productId,
      'adminId': adminId,
      'featureImages': featureImages,
      'price': price,
      'category': category.name,  // Convert enum to String
      'time': time.toIso8601String(),  // Convert DateTime to ISO 8601 string
      'mainImage': mainImage,
      'description': description,
      'productTitle': productTitle,
    };
  }

  // Create ProductModal from JSON
  factory ProductModal.fromJson(Map<String, dynamic> json) {
    return ProductModal(
      buyCount: json['buyCount'],
      productId: json['productId'],
      adminId: json['adminId'],
      featureImages: List<String>.from(json['featureImages']),
      price: json['price'].toDouble(),
      category: ProductCategory.values.firstWhere(
              (e) => e.name == json['category']), // Convert String to enum
      time: DateTime.parse(json['time']), // Convert ISO 8601 string to DateTime
      mainImage: json['mainImage'],
      description: json['description'],
      productTitle: json['productTitle'],
    );
  }

}
