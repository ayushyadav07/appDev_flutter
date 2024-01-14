import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(image: 'assets/1.jpg', name: 'Macbook Air', price: 19.99),
    Product(image: 'assets/2.jpeg', name: 'HP Pavilion', price: 19.99),
    Product(image: 'assets/3.jpeg', name: 'Asus Vivobook', price: 19.99),
    Product(image: 'assets/4.jpg', name: 'Lenovo Yoga', price: 19.99),
    Product(image: 'assets/5.webp', name: 'Samsung', price: 19.99),
    Product(image: 'assets/6.jpeg', name: 'Acer', price: 19.99),
    Product(image: 'assets/7.jpg', name: 'Asus Zenbook', price: 19.99),
    Product(image: 'assets/8.jpeg', name: 'Dell XPS 13 Plus', price: 19.99),
    Product(image: 'assets/9.jpeg', name: 'Dell Xps 13', price: 19.99),
    Product(image: 'assets/10.jpeg', name: 'Huawei MateBook 13', price: 19.99),
  ];

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Product List'),
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, CartScreen.routeName);
          },
        ),
      ],
    ),
    body: ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        var product = products[index];
        var isInCart =
            Provider.of<CartProvider>(context).cartItems.contains(product);

        return ListTile(
          contentPadding: EdgeInsets.all(8.0), // Add padding to the entire ListTile
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
          trailing: isInCart
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .removeFromCart(product);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .removeFromCart(product);
                      },
                    ),
                  ],
                )
              : IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(product);
                  },
                ),
        );
      },
    ),
  );
}
}
