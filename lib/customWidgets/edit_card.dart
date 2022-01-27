import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/widgetConstants.dart';
import '../customWidgets/counter.dart';

class EditCard extends StatefulWidget {
  const EditCard({Key? key}) : super(key: key);

  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  dynamic _pickedImage = '';
  dynamic _img;

  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic> _enteredData = {};

  var _itemName = '';
  var _itemPrice = '';
  var _currVal = 1;
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
    if (_img == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select an image',
          ),
        ),
      );
      return;
    }
    formKey.currentState!.save();

    final ref = FirebaseStorage.instance
        .ref()
        .child('grocery_items')
        .child(_itemName + '.jpg');

    await ref.putFile(File(_img));

    final _imageUrl = ref.getDownloadURL();

    _enteredData = {
      'id': DateTime.now().toIso8601String(),
      'name': _itemName,
      'price': double.parse(_itemPrice) * _currVal,
      'quantity': _currVal,
      'imagePath': _imageUrl,
    };

    formKey.currentState!.reset();
    FirebaseFirestore.instance.collection('grocery').add(_enteredData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Item added successfully !',
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
        height: dimensions.size.height * 0.5,
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
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: _img == null
                              ? null //FileImage(File('Grocery-App/assets/icons/groc_vector.png'))
                              : FileImage(
                                  File(_img),
                                ),
                          backgroundColor: Colors.grey,
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
                        initialValue: '',
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
                        initialValue: '',
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
