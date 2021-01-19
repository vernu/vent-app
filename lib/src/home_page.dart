import 'package:flutter/material.dart';
import 'package:vent/src/pages/signin_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final _tabPages = <Widget>[Text('Home'), SiginPage()];
    final _bottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
          icon: Icon(Icons.home), title: Text('Home')),
      const BottomNavigationBarItem(
          icon: Icon(Icons.person), title: Text('Account')),
    ];
    assert(_tabPages.length == _bottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
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
