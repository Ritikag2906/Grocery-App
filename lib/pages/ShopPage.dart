import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/Models/grocery_model.dart';
import 'package:grocery_app/customWidgets/GroceryCards.dart';
import 'package:grocery_app/customWidgets/customdialoguebox.dart';
import 'package:grocery_app/providers/grocery_list.dart';
import 'package:grocery_app/services/db_service.dart';
import 'package:grocery_app/utils/widgetConstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<GroceryModel> groceryList = [];

  void _loadJson() async {
    setState(() {});
    _refreshController.refreshCompleted();
  }

  List<String> _selectedList = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        backgroundColor: GlobalColors.primaryColor,
      ),
      body: Consumer(
        builder: (context, watch, child) {
          return watch(groceryListProvider).when(
            data: (value) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: value.isNotEmpty
                  ? SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: false,
                      header: const ClassicHeader(
                        completeIcon:
                            Icon(Icons.done, color: GlobalColors.primaryColor),
                        refreshingIcon: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: GlobalColors.primaryColor,
                          ),
                        ),
                      ),
                      onRefresh: () => _loadJson(),
                      child: GridView.count(
                        childAspectRatio: 1,
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: List.generate(
                          value.length,
                          (i) {
                            return GestureDetector(
                              onLongPress: () {
                                HapticFeedback.vibrate();
                                setState(() {
                                  _selectedList.add(value[i].docId);
                                });
                              },
                              onTap: _selectedList.isNotEmpty
                                  ? () {
                                      HapticFeedback.mediumImpact();
                                      setState(() {
                                        _selectedList.contains(value[i].docId)
                                            ? _selectedList
                                                .remove(value[i].docId)
                                            : _selectedList.add(value[i].docId);
                                      });
                                    }
                                  : () {
                                      HapticFeedback.mediumImpact();
                                      showCupertinoDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) => Theme(
                                                data: ThemeData.dark(),
                                                child: CupertinoAlertDialog(
                                                    title: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Text(value[i]
                                                          .name
                                                          .toString()),
                                                    ),
                                                    content: CustomDialogueBox(
                                                      id: value[i].id,
                                                      docId: value[i].docId,
                                                      image: value[i]
                                                          .imagePath
                                                          .toString(),
                                                      price: value[i]
                                                          .price
                                                          .toString(),
                                                      quantity: value[i]
                                                          .quantity
                                                          .toString(),
                                                    )),
                                              ));
                                    },
                              child: Transform.scale(
                                scale: _selectedList.contains(value[i].docId)
                                    ? 1.02
                                    : 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                  child: Stack(children: [
                                    GroceryCards(
                                      title: value[i].name,
                                      price: value[i].price.toString(),
                                      image: value[i].imagePath,
                                      quantity: value[i].quantity.toString(),
                                    ),
                                    if (_selectedList.isNotEmpty)
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Icon(Icons.check_circle,
                                            color: _selectedList
                                                    .contains(value[i].docId)
                                                ? GlobalColors.primaryColor
                                                : Colors.grey),
                                      )
                                  ]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 60,
                          color: GlobalColors.secondaryColor.withOpacity(0.4),
                        ),
                        Text(
                          'No Items',
                          style: TextStyle(
                              color:
                                  GlobalColors.secondaryColor.withOpacity(0.5),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
            ),
            loading: () => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: GlobalColors.primaryColor,
                ),
              ],
            )),
            error: (error, stackTrace) => Text('error: $error'),
          );
        },
      ),
      bottomNavigationBar: _selectedList.isNotEmpty
          ? SizedBox(
              height: 50,
              child: ListTile(
                tileColor: Colors.black,
                leading: IconButton(
                  icon: SvgPicture.asset("assets/icons/delete.svg"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => deleteDialog(context));
                  },
                ),
                title: Text(
                  _selectedList.length.toString() + ' Selected',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedList.clear();
                    });
                  },
                ),
              ),
            )
          : const SizedBox(
              height: 0,
            ),
    );
  }

  AlertDialog deleteDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(vertical: 38, horizontal: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Do you want to remove " +
                _selectedList.length.toString() +
                " selected items ?",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Selected items will be removed from your the list",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 48,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  List<GroceryModel> temp = [];
                  for (int i = 0; i < _selectedList.length; i++) {
                    DatabaseService().deleteCollection(_selectedList[i]);
                  }
                  // setState(() {});
                  SnackBar s = SnackBar(
                    elevation: 6.0,
                    backgroundColor: const Color(0xff2c2c2e),
                    behavior: SnackBarBehavior.floating,
                    content: Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: GlobalColors.primaryColor,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Removed from list",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                  Navigator.of(context).pop();
                  _selectedList.clear();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    s,
                  );
                  // _loadJson();
                },
                child: Container(
                  height: 48,
                  width: 220,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                      child: Text(
                    "Remove",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 220,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                      child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  )),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
