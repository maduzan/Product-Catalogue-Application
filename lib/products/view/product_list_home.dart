import 'package:flutter/material.dart';

class ProductListHome extends StatefulWidget {
  const ProductListHome({super.key});

  @override
  _ProductListHomeState createState() => _ProductListHomeState();
}

class _ProductListHomeState extends State<ProductListHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
