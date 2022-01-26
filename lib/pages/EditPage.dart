import 'package:flutter/material.dart';
import 'package:grocery_app/customWidgets/home_card.dart';
import 'package:grocery_app/utils/widgetConstants.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit a product'),
        backgroundColor: GlobalColors.primaryColor,
      ),
      body: HomeCard(),
    );
  }
}
