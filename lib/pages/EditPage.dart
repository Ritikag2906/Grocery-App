import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/customWidgets/home_card.dart';
import 'package:grocery_app/utils/widgetConstants.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('grocery')
        .where('id, {2022-01-27T16:57:35.005363}')
        .get()
        .then((value) => print({...value.docs.asMap()}));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit a product'),
        backgroundColor: GlobalColors.primaryColor,
      ),
    );
  }
}
