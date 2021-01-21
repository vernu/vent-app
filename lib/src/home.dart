import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vent/src/pages/categories_and_tags_page.dart';
import 'package:vent/src/pages/home_page.dart';
import 'package:vent/src/pages/my_account_page.dart';
import 'package:vent/src/pages/signin_page.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final _tabPages = <Widget>[
      HomePage(),
      CategoriesAndTagsPage(),
      FirebaseAuth.instance.currentUser != null ? MyAccountPage() : SiginPage(),
    ];
    final _bottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
          icon: Icon(Icons.home), title: Text('Home')),
      const BottomNavigationBarItem(
          icon: Icon(Icons.category), title: Text('Categories and Tags')),
      const BottomNavigationBarItem(
          icon: Icon(Icons.person), title: Text('Account')),
    ];
    assert(_tabPages.length == _bottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: _bottmonNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() => _currentTabIndex = index);
        _pageController.animateToPage(index,
            duration: Duration(milliseconds: 500), curve: Curves.easeOut);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Vent'),
        actions: [],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentTabIndex = index);
          },
          children: _tabPages,
        ),
      ),
      bottomNavigationBar: bottomNavBar,
    );
  }
}
