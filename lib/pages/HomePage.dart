import 'package:flutter/material.dart';

import '../customWidgets/home_card.dart';

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
        title: const Text('Add Item'),
      ),
      body: const HomeCard(),
    );
  }
}
