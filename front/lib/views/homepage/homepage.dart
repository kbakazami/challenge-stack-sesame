import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:front/views/customer/qrcode.dart';
import 'package:front/views/homepage/widgets/navbar-icons.dart';
import '../../constants/colors.dart';
import '../auth/login.dart';
import '../customer/account.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  final List<Widget> _widgetOptions = <Widget>[
    const Login(),
    const QrCode(),
    const Account(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildNavigator(),
        ],
      ),
      bottomNavigationBar: customNavigationBar(context),
    );
  }

  Widget customNavigationBar(context) {
    return Align(
      alignment: Alignment.bottomCenter,
      //this is very important, without it the whole screen will be blurred
      child: ClipRect(
        //I'm using BackdropFilter for the blurring effect
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.8,
            sigmaY: 3.8,
          ),
          child: Opacity(
            //you can change the opacity to whatever suits you best
              opacity: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  border: Border(top: BorderSide(color: Colors.white, width: 1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NavbarIcon(null, 'status.svg' , 0, _selectedIndex, onItemTapped: _onItemTapped),
                    NavbarIcon(30, 'qrcode.svg' , 1, _selectedIndex, onItemTapped: _onItemTapped),
                    NavbarIcon(null, 'customer.svg' , 2, _selectedIndex, onItemTapped: _onItemTapped),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }

  buildNavigator() {
    return Navigator(
      key: navigatorKeys[_selectedIndex],
      onGenerateRoute: (RouteSettings setting) {
        if(setting.name != "/") {
          switch(setting.name) {
            case "login":
              print("login case");
              return MaterialPageRoute(builder: (_) => const Login());

            case "account":
              print("account case");
              return MaterialPageRoute(builder: (_) => const Account());
          }
        } else {
          return MaterialPageRoute(builder: (_) => _widgetOptions.elementAt(_selectedIndex));
        }
      },
    );
  }
}