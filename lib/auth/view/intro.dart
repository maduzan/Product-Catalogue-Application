import 'package:flutter/material.dart';

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
      body: ExtendedColumn(
        children: [
          const SizedBox(height: 40),
          //const AppLogo(aspectRatio: 16 / 9),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: Text('Sign In')),
        ],
      ),
    );
  }
}
