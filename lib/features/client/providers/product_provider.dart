import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_task/features/client/presentation/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List <Product> _products = [];

  List <Product> get products => _products;

  Future <void> fetchProducts() async{
    try{
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      _products = snapshot.docs.map((doc) {
        return Product(
          name: doc['name'], 
          price: doc['price'], 
          desc: doc['desc'],
          );
      }).toList();

      notifyListeners();
    } catch(e) {
      print('Error fetching products: $e');
    }
  }
}
