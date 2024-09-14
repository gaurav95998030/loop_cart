




import 'package:flutter_riverpod/flutter_riverpod.dart';
enum PaymentMethod{Cash,UPI}
final paymentMethodProvider = StateProvider<PaymentMethod>((ref)=>PaymentMethod.Cash);