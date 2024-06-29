import 'package:aceacademy/Scrrens/mycourses.dart';
import 'package:aceacademy/Scrrens/profile.dart';
import 'package:aceacademy/Scrrens/search.dart';
import 'package:aceacademy/backend/addvideos.dart';
import 'package:aceacademy/backend/course_add.dart';
import 'package:aceacademy/Scrrens/courses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'home.dart';

class DrAWER extends StatefulWidget {
  const DrAWER({super.key});

  @override
  State<DrAWER> createState() => _DrAWERState();
}

class _DrAWERState extends State<DrAWER> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Home',

              baseStyle: TextStyle(fontSize: 18, color: Colors.white),
              selectedStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple)),
          HomeScreen()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              baseStyle: TextStyle(fontSize: 18, color: Colors.white),
              name: 'Courses',
              selectedStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple)),
          CoursesScreen()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'My Courses',
              baseStyle: TextStyle(fontSize: 18, color: Colors.white),
              selectedStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple)),
          MyCoursesScreen()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Profile',
              baseStyle: TextStyle(fontSize: 18, color: Colors.white),
              selectedStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple)),
          ProfileScr()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(

              name: 'Settings',
              baseStyle: TextStyle(fontSize: 18,color: Colors.white),
              selectedStyle: TextStyle(  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple)),
          HomeScreen()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(

      backgroundColorAppBar: Colors.transparent,
      elevationAppBar: 0,
      actionsAppBar: [

        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
            icon: Icon(Icons.search,color: Colors.white,)),
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_outlined,color: Colors.white,)),

      ],
      styleAutoTittleName: TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purpleAccent[100]),
      slidePercent: 50,
      screens: _pages,
      initPositionSelected: 0,
      backgroundColorMenu: Colors.transparent,
      backgroundMenu: DecorationImage(image: AssetImage('assets/images/bg1.jpg'),fit: BoxFit.cover),
      backgroundColorContent: Colors.transparent.withOpacity(0),


    );
  }
}
