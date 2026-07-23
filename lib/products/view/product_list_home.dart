import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../auth/controller/controller.dart';

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
        actions: [
          IconButton(
              onPressed: () {
                GetIt.instance<AuthService>().logout();
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              )),
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
