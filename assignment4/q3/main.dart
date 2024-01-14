import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/product_list_screen.dart';
import 'screens/cart_screen.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        home: ProductListScreen(),
        routes: {
          CartScreen.routeName: (context) => CartScreen(),
        },
      ),
    );
  }
}
