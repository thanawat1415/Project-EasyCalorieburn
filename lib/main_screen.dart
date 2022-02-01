import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mobile_final/screens/Friend/friends_screen.dart';
import 'package:mobile_final/screens/history_screen.dart';
import 'package:mobile_final/screens/home_screen.dart';
import 'package:mobile_final/screens/profile_screen.dart';
import 'package:mobile_final/screens/setting_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int pageIndex = 0;
  List<Widget> pageList = <Widget>[
    const HomeScreen(),
    const HistoryScreen(),
    const FriendScreen(),
    const ProfileScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: pageList[pageIndex],
      body: PageTransitionSwitcher(transitionBuilder:(child,primaryAnimation,secondaryAnimation)=>FadeThroughTransition(
        animation: primaryAnimation, 
        secondaryAnimation: secondaryAnimation,
        child: child,
          ),
          child: pageList[pageIndex],
        ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[200],
        selectedIconTheme:IconThemeData(color: Colors.white),
        selectedItemColor: Colors.white70,
        currentIndex: pageIndex,
        onTap: (value){
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history),label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person_add),label: "Friends"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings"),
        ],
      ),
    );
  }
}