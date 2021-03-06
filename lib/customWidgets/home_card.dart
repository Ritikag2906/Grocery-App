import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/widgetConstants.dart';
import '../customWidgets/counter.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({Key? key}) : super(key: key);

  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  dynamic _pickedImage = '';
  dynamic _img;

  final _text1 = TextEditingController();
  final _text2 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic> _enteredData = {};

  var _itemName = '';
  var _itemPrice = '';
  var _currVal = 1;
  dynamic _imageSource;
  var _loading = false;

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
      _pickedImage = await ImagePicker().pickImage(
        source: _imageSource,
        imageQuality: 70,
      );
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

    setState(() {
      _loading = true;
    });

    final ref = FirebaseStorage.instance
        .ref()
        .child('grocery_items')
        .child(_itemName + '.jpg');

    await ref.putFile(File(_img));

    final _imageUrl = await ref.getDownloadURL();

    _enteredData = {
      'id': DateTime.now().toIso8601String(),
      'name': _itemName,
      'price': double.parse(_itemPrice) * _currVal,
      'quantity': _currVal,
      'imagePath': _imageUrl,
    };

    DocumentReference<Map<String, dynamic>> temp = await FirebaseFirestore
        .instance
        .collection('grocery')
        .add(_enteredData);

    formKey.currentState!.reset();
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = false;
      _img = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Item added successfully !',
        ),
      ),
    );
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: _img != null
                                ? Image.file(
                                    File(_img),
                                    width: dimensions.size.width * 0.3,
                                    height: dimensions.size.height * 0.15,
                                    fit: BoxFit.cover,
                                    colorBlendMode: BlendMode.clear,
                                  )
                                : Image.network(
                                    'https://cdn.dribbble.com/users/67525/screenshots/4517042/media/c6f7c8b0db834cdc49ef538acdb65702.png?compress=1&resize=400x300',
                                    height: dimensions.size.height * 0.15,
                                    width: dimensions.size.width * 0.3,
                                    fit: BoxFit.cover,
                                    colorBlendMode: BlendMode.clear,
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
                      const SizedBox(
                        height: 20,
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
                      _loading
                          ? const CircularProgressIndicator.adaptive()
                          : ElevatedButton.icon(
                              onPressed: _addProduct,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Item'),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
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
