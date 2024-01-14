import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          var product = cartItems[index];

          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0), // Add margin between ListTiles
            child: ListTile(
              leading: Container(
                width: 80.0, // Set width for the product image
                child: Image.asset(product.image, fit: BoxFit.cover),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0), // Add margin between image and product name
                  Text(product.name),
                  SizedBox(height: 4.0), // Add margin between product name and price
                  Text('\$${product.price}'),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: \$${cartProvider.getTotalPrice().toStringAsFixed(2)}'),
              ElevatedButton(
                onPressed: () {
                  cartProvider.clearCart();
                  Navigator.pop(context);
                },
                child: Text('BUY'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
