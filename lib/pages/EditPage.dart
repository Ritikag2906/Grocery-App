import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/customWidgets/home_card.dart';
import 'package:grocery_app/utils/widgetConstants.dart';

class EditPage extends StatefulWidget {
  final DateTime id;

  const EditPage({Key? key, required this.id}) : super(key: key);
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
        .where('id', isEqualTo: widget.id.toIso8601String()
            //  Timestamp.fromDate(widget.id)
            )
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
