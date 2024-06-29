import 'dart:ui';

import 'package:aceacademy/Scrrens/mycourses.dart';
import 'package:aceacademy/components/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'editProfile.dart';

class ProfileScr extends StatefulWidget {
  const ProfileScr({Key? key}) : super(key: key);

  @override
  State<ProfileScr> createState() => _ProfileScrState();
}

class _ProfileScrState extends State<ProfileScr> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    // Get the current user
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        // Extract user data
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>;
          _isLoading = false; // Set loading to false once data is fetched
        });
      } catch (error) {
        // Handle error
        print('Error fetching user data: $error');
        setState(() {
          _isLoading = false; // Set loading to false if an error occurs
        });
      }
    } else {
      print('User is not logged in');
      setState(() {
        _isLoading = false; // Set loading to false if user is not logged in
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userData != null
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(9)),
                        child: FrostedGlass(
                          child: SizedBox(
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                        'assets/images/pro1.png',
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    Text(
                                      _userData!['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      _userData!['email'],
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  // top: 10,
                                  right: 5,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProfileScreen(userData: _userData),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.mode_edit_outline),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          .box
                          .padding(EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10))
                          .makeCentered(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(9)),
                              child: FrostedGlass(
                                child: Text(
                                  _userData!['school'],
                                  style: TextStyle(color: Colors.white),
                                ).centered(),
                              ),
                            ),
                          ),
                          15.widthBox,
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(9)),
                              child: FrostedGlass(
                                child: Text(
                                  _userData!['phone'],
                                  style: TextStyle(color: Colors.white),
                                ).centered(),
                              ),
                            ),
                          ),
                        ],
                      )
                          .box
                          .width(double.infinity)
                          .margin(EdgeInsets.symmetric(horizontal: 10))
                          .p4
                          .make(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(9)),
                              child: FrostedGlass(
                                child: Text(
                                  'No. of Courses Enrolled : ${_userData!['courses'].length}',
                                  style: TextStyle(color: Colors.white),
                                ).centered(),
                              ),
                            ),
                          ),
                          15.widthBox,
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(9)),
                              child: FrostedGlass(
                                child: Text(
                                  'No. of Videos Watched : ${_userData!['recent'].length}',
                                  style: TextStyle(color: Colors.white),
                                ).centered(),
                              ),
                            ),
                          ),
                        ],
                      )
                          .box
                          .width(double.infinity)
                          .margin(EdgeInsets.symmetric(horizontal: 10))
                          .p4
                          .make(),

                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(9)),
                        child: FrostedGlass(
                            child: ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              title: Text(
                                'My Courses',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                              leading: Icon(
                                Icons.video_library,
                                color: Colors.white,
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> MyCoursesScreen()));
                              },
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            ListTile(
                              title: Text(
                                'Settings',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                              leading: Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            ListTile(
                              title: Text(
                                'Help',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                              leading: Icon(
                                Icons.help,
                                color: Colors.white,
                              ),
                            ),

                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            ListTile(
                              title: Text(
                                'Logout',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                              leading: Icon(
                                Icons.logout,
                                color: Colors.red[800],
                              ),onTap: () async{
                              await FirebaseAuth.instance.signOut();
                            },
                            ),
                          ],
                        )),
                      ),

                    ],
                  ))
              : Center(child: CircularProgressIndicator()),
    );
  }
}

class FrostedGlass extends StatelessWidget {
  final Widget child;

  const FrostedGlass({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ),
    );
  }
}
