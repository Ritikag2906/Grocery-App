import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/Models/grocery_model.dart';
import 'package:grocery_app/customWidgets/GroceryCards.dart';
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
    var jsonData =
        await rootBundle.loadString('assets/instrument/grocery_list.json');
    groceryList = groceryFromJson(jsonData);
    setState(() {});
    _refreshController.refreshCompleted();
  }

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
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          header: const ClassicHeader(
            completeIcon: Icon(Icons.done, color: GlobalColors.primaryColor),
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
            childAspectRatio: 0.89,
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: List.generate(
              groceryList.length,
              (i) {
                return GroceryCards(
                  title: groceryList[i].name.toString(),
                  price: groceryList[i].price.toString(),
                  image: groceryList[i].image.toString(),
                );
              },
            ),
          ),
        ));
  }
}
