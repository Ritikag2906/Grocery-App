import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/widgetConstants.dart';
import '../customWidgets/counter.dart';

class EditCard extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> data;

  EditCard(this.data);

  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  dynamic _pickedImage = '';
  dynamic _img;

  var _itemName = '';
  var _itemPrice = '';
  var _currVal = 1;
  var _userImage = '';

  var documentId = '';

  @override
  void initState() {
    widget.data.data!.docs.forEach((element) {
      var _temp = element.data();
      double temp = _temp['price'];
      _itemName = _temp['name'];
      _itemPrice = temp.toString();
      _currVal = _temp['quantity'];
      _userImage = _temp['imagePath'];
      documentId = element.id;
    });

    super.initState();
  }

  Map<String, dynamic> _enteredData = {};

  dynamic _imageSource;

  Future<void> _pickImage() async {
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Please select a method'),
                const Divider(
                  thickness: 0.8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        _imageSource = ImageSource.camera;
                        Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text('Camera'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _imageSource = ImageSource.gallery;
                        Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Gallery'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      _pickedImage = await ImagePicker().pickImage(source: _imageSource);
      setState(() {
        _img = _pickedImage!.path;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _addProduct() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    // if (_img =) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //         'Please select an image',
    //       ),
    //     ),
    //   );
    //   return;
    // }
    formKey.currentState!.save();

    final ref = FirebaseStorage.instance
        .ref()
        .child('grocery_items')
        .child(_itemName + '.jpg');

    print(_userImage);
    if (_img == null) {
      await ref.putFile(File.fromUri(Uri.parse(_userImage)));
    } else {
      await ref.putFile(File(_img));
    }

    final _imageUrl = ref.getDownloadURL();

    _enteredData = {
      'id': DateTime.now().toIso8601String(),
      'name': _itemName,
      'price': double.parse(_itemPrice) * _currVal,
      'quantity': _currVal,
      'imagePath': _imageUrl,
    };

    formKey.currentState!.reset();
    // FirebaseFirestore.instance.collection('grocery').add(_enteredData);
    await http.patch(
      Uri.parse(
          'https://firestore.googleapis.com/v1/projects/[groceryapp-3e624]/databases/(default)/documents/[grocery]/[$documentId]?currentDocument.exists=true&updateMask.fieldPaths=name&alt=json'),
      body: json.encode(_enteredData),
    ); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Item updated successfully !',
        ),
      ),
    );

    setState(() {
      _img = null;
    });
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final dimensions = MediaQuery.of(context);
    return Center(
      child: Container(
        height: dimensions.size.height * 0.58,
        width: dimensions.size.width * 85,
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: _img != null
                                ? Image.file(
                                    File(_img),
                                    width: dimensions.size.width * 0.3,
                                    height: dimensions.size.height * 0.15,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    _userImage,
                                    height: dimensions.size.height * 0.15,
                                    width: dimensions.size.width * 0.3,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Icons.image,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: _pickImage,
                        label: Text(
                          'Add Image',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      TextFormField(
                        initialValue: _itemName,
                        decoration: const InputDecoration(
                          label: Text('Item Name'),
                        ),
                        onSaved: (val) {
                          _itemName = val ?? '';
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter valid item name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _itemPrice,
                        maxLength: 5,
                        decoration: const InputDecoration(
                          label: Text('Price'),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter valid price';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _itemPrice = val ?? '';
                        },
                        keyboardType: TextInputType.number,
                      ),
                      Counter(
                        color: GlobalColors.primaryColor,
                        initialValue: _currVal,
                        minValue: 1,
                        maxValue: 100,
                        step: 1,
                        onChanged: (n) {
                          setState(() {
                            _currVal = n;
                          });
                        },
                        buttonSize: 25,
                        decimalPlaces: 0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: _addProduct,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Item'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
