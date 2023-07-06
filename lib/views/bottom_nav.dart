import 'package:flutter/material.dart';
import 'package:grocery_app/views/account_screen.dart';
import 'package:grocery_app/views/home_screen.dart';
import 'package:grocery_app/views/order_details_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:grocery_app/utils/hex_color.dart';

class BottomNav extends StatefulWidget {

  const BottomNav({Key key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();

}

class _BottomNavState extends State<BottomNav> {

  PersistentTabController _controller;

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      OrderDetailsScreen(),
      AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }

  Future<void> init () async {
    _controller = PersistentTabController(initialIndex: 0);
    setState(() {

    });
  }

  @override
  void initState () {
    super.initState();
    init();
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'inter-medium',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        icon: ImageIcon(
          AssetImage("assets/images/home.png"),
        ),
        title: ("Home"),
        activeColorPrimary: HexColor("#66906A"),
        inactiveColorPrimary: HexColor("#AAAAAA"),
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'inter-medium',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        icon: ImageIcon(
          AssetImage("assets/images/box.png"),
        ),
        title: ("Orders"),
        activeColorPrimary: HexColor("#66906A"),
        inactiveColorPrimary: HexColor("#AAAAAA"),
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'inter-medium',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        icon: ImageIcon(
          AssetImage("assets/images/profile.png"),
        ),
        title: ("Admin"),
        activeColorPrimary: HexColor("#66906A"),
        inactiveColorPrimary: HexColor("#AAAAAA"),
      ),
    ];
  }

}
