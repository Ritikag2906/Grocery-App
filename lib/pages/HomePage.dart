import 'package:flutter/material.dart';

import '../customWidgets/card.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/AddProduct';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddProduct'),
      ),
      body: const HomeCard(),
    );
  }
}
