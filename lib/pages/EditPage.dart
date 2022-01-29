import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/customWidgets/edit_card.dart';
import 'package:grocery_app/customWidgets/home_card.dart';
import 'package:grocery_app/utils/widgetConstants.dart';

class EditPage extends StatefulWidget {
  final DateTime id;

  const EditPage({Key? key, required this.id}) : super(key: key);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // Item groceryItem = Item();

  _loadData() async {
    var data = await FirebaseFirestore.instance
        .collection('grocery')
        .where('id', isEqualTo: widget.id.toIso8601String())
        .get();

    setState(() {
      // groceryItem = Item.fromJson(data.docs[0].data());
      // print(groceryItem);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('grocery')
        .where('id', isEqualTo: widget.id.toIso8601String())
        .get()
        .then(
          (value) => print(
            {
              value.docs.forEach(
                (element) {
                  print(element.id);
                },
              )
            },
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit a product'),
        backgroundColor: GlobalColors.primaryColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('grocery')
            .where('id', isEqualTo: widget.id.toIso8601String())
            .get(),
        builder: (_, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                        color: GlobalColors.primaryColor),
                  ],
                ))
              : EditCard(snapshot
                  as AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>);
        },
      ),
    );
  }
}
