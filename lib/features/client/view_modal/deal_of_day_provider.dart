




import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/client/services/client_services.dart';

import '../../admin/modals/product_modal.dart';

final dealOfDayProvider = FutureProvider<ProductModal?>((ref) async {
  return ClientServices.getDealOfTheDay();
});
