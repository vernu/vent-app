import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/categories_and_tags/categories_and_tags_bloc.dart';
import 'package:vent/src/blocs/home_nav/home_nav_cubit.dart';
import 'package:vent/src/blocs/vents/vents_bloc.dart';
import 'package:vent/src/ui/pages/account_page.dart';
import 'package:vent/src/ui/pages/categories_and_tags_page.dart';
import 'package:vent/src/ui/pages/home_page.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeNavCubit()),
        BlocProvider(create: (_) => VentsBloc()..add(VentsLoadRequested())),
        BlocProvider(
            create: (_) =>
                CategoriesAndTagsBloc()..add(CategoriesAndTagsLoadRequested())),
      ],
      child: BlocBuilder<HomeNavCubit, HomeNavState>(
        builder: (context, state) {
          print(state.selectedIndex);
          return Scaffold(
            appBar: AppBar(
              leading: (() {
                switch (state.selectedIndex) {
                  case 0:
                    return Icon(CupertinoIcons.home);
                    break;
                  case 1:
                    return Icon(CupertinoIcons.tags);
                    break;
                  case 2:
                    return Icon(CupertinoIcons.person);
                    break;
                  default:
                    return Icon(CupertinoIcons.home);
                    break;
                }
              }()),
              title: (() {
                switch (state.selectedIndex) {
                  case 0:
                    return Text('Home');
                    break;
                  case 1:
                    return Text('Categories and Tags');
                    break;
                  case 2:
                    return Text('My Account');
                    break;
                  default:
                    return Text('Vent');
                    break;
                }
              }()),
              actions: [
                IconButton(
                  icon: Icon(CupertinoIcons.gear),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  tooltip: 'Settings',
                )
              ],
            ),
            body: SafeArea(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  context.read<HomeNavCubit>().changeCurrentIndex(index);
                },
                children: [
                  HomePage(),
                  CategoriesAndTagsPage(),
                  AccountPage(),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text('Home')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.category),
                    title: Text('Categories and Tags')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text('Account')),
              ],
              currentIndex: state.selectedIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                context.read<HomeNavCubit>().changeCurrentIndex(index);
                _pageController.jumpToPage(index);
                // _pageController.animateToPage(index,
                //     duration: Duration(milliseconds: 500),
                //     curve: Curves.easeOut);
              },
            ),
          );
        },
      ),
    );
  }
}
