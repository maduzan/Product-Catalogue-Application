import 'package:Product_Catalogue_Application/app/widgets/logo.dart';
import 'package:flutter/material.dart';

import '../../utils/pages.dart';
import '../../utils/utils.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inro Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ExtendedColumn(
        children: [
          const SizedBox(height: 40),
          const AppLogo(imageWidth: 600, imageHeight: 300),
          FixedGap(mainAxisExtent: 40),
          Center(
              child: Text(
            '.....Enjoy Yourself!......',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                Pages.signIn.go(context);
              },
              child: Text('Sign In')),
          RelativeGap(mainAxisExtent: 0.05)
        ],
      ),
    );
  }
}
