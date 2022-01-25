import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/pages/HomePage.dart';
import 'package:grocery_app/pages/ShopPage.dart';
import 'package:grocery_app/utils/widgetConstants.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schaffen Grocery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentindex = 0;

  final List<Widget> _children = [
    const HomePage(),
    const ShopPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentindex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        child: CustomLineIndicatorBottomNavbar(
          selectedColor: GlobalColors.primaryColor,
          unSelectedColor: const Color(0xff8A8A8A),
          backgroundColor: Colors.white,
          currentIndex: _currentindex,
          onTap: (index) {
            setState(() {
              _currentindex = index;
            });
          },
          enableLineIndicator: true,
          lineIndicatorWidth: 3.5,
          indicatorType: IndicatorType.Top,
          customBottomBarItems: [
            CustomBottomBarItems(
              label: 'Home',
              icon: Icons.home_outlined,
            ),
            CustomBottomBarItems(label: 'Shop', icon: Icons.shopping_bag),
          ],
        ),
      ),
    );
  }
}
