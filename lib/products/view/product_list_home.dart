import 'package:Product_Catalogue_Application/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../app/controller/controller.dart';
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
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Switch(
              value: GetIt.instance<ThemeServiceProvider>().isDark,
              onChanged: (value) {
                GetIt.instance<ThemeServiceProvider>().toggleTheme();
              },
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
        body: ExtendedColumn(children: [
          FixedGap(mainAxisExtent: 24),
          CommonSearchBar(
            hintText: 'Search products...',
            onChanged: (query) {
              print('Searching: $query');
            },
            onSubmitted: (query) {
              print('Submitted search: $query');
            },
          )
        ]));
  }
}
