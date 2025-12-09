import 'package:first_task/features/client/presentation/models/cart_model.dart';
import 'package:first_task/features/client/presentation/models/product_model.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => _items ;

  void addToCart(Product product){
    if (_items.containsKey(product.name)){
      items[product.name]!.quantity++;
    } else {
      _items[product.name] =  CartItem(product: product);
    }
    notifyListeners();
  }

  void removeFromCart(String productName){
    _items.remove(productName);
    notifyListeners();
  }

  void increaseQuantity(String productName){
    _items[productName]!.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(String productName){
    if (_items[productName]!.quantity > 1){
      _items[productName]!.quantity--;
    } else{
      _items.remove(productName);
    }
    notifyListeners();
  }

  void clearCart(){
    _items.clear();
    notifyListeners();
  }

  double get totalPrice{
    double total = 0.0;
    _items.forEach((key, cartItem){
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  int get itemCount => items.length;
}