
enum ProductCategory {
  Mobile,
  Laptop,
  Tv,
  Clothes,

  Books,



}



Map<ProductCategory,String> categoryIcons = {
  ProductCategory.Books:'assets/images/product_category/Books.png',
 // ProductCategory.Beauty:'assets/images/product_category/Beauty.png',
  ProductCategory.Clothes:'assets/images/product_category/Clothes.png',
 // ProductCategory.Electronics:'assets/images/product_category/Electronics.png',
//  ProductCategory.Furniture:'assets/images/product_category/Furniture.png',
  //ProductCategory.Groceries:'assets/images/product_category/Groceries.png',
  //ProductCategory.Health:'assets/images/product_category/Health.png',
  ProductCategory.Laptop:'assets/images/product_category/Laptop.png',
  ProductCategory.Mobile:'assets/images/product_category/Mobile.png',
 // ProductCategory.Sports:'assets/images/product_category/Sports.png',
  //ProductCategory.Toys:'assets/images/product_category/Toys.png',
  ProductCategory.Tv:'assets/images/product_category/TV.png',
 // ProductCategory.HomeAppliances:'assets/images/product_category/HomeApliances.png'
};



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
  bool isAvailable;
  double rating;

  ProductModal({required this.isAvailable,required this.rating,required this.buyCount,required this.price,required this.category,required this.adminId,required this.description,required this.featureImages,required this.mainImage,required this.productId,required this.productTitle,required this.time});

  Map<String, dynamic> toJson() {
    return {
      'rating':rating,
      'isAvailable':isAvailable,
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
      rating: json['rating'].toDouble(),
      isAvailable:json['isAvailable'],
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
