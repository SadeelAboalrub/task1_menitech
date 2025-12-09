import 'package:first_task/features/client/presentation/models/product_model.dart';

class CartItem{

  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity =1,
  });
}