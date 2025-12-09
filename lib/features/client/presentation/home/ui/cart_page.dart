import 'package:first_task/features/client/presentation/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_task/features/client/providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Cart",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          final items = cart.items.values.toList();

          if (items.isEmpty) {
            return const Center(
              child: Text("Your Cart is Empty", style: TextStyle(fontSize: 18)),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index){
                    final CartItem = items[index];
                    final product = CartItem.product;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          "${product.price}\$ ${CartItem.quantity}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: (){
                                cart.decreaseQuantity(product.name);
                              }, 
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              CartItem.quantity.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                                icon:  const Icon(Icons.add),
                                onPressed: (){
                                  cart.increaseQuantity(product.name);
                                },
                              ),
                              IconButton(
                                onPressed: (){
                                  cart.removeFromCart(product.name);
                                }, 
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }
                )
              ),

              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total: ${cart.totalPrice.toStringAsFixed(2)} \$",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: (){}, 
                      child: const Text("CheckOut"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
