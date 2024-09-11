



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/client/services/client_services.dart';

final categoryProductsProvider = FutureProvider.family<List<ProductModal>, String>((ref, category) async {
  print(category);
  return ClientServices.loadProductsWithCategory(category);
});