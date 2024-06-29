import 'package:aceacademy/authentication/signup.dart';
import 'package:aceacademy/backend/course_add.dart';
import 'package:aceacademy/components/buttons.dart';
import 'package:aceacademy/components/color.dart';
import 'package:aceacademy/components/textfield.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Scrrens/drawer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailControl = TextEditingController();


  TextEditingController passwordControl = TextEditingController();




  Future<void> signInUser() async {

    String email = emailControl.text;


    try{
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email, password: passwordControl.text);

      String uid = userCredential.user!.uid;



    }catch (err){
      print(err.toString());
    }
  }

  @override
  void dispose() {
    emailControl.dispose();
    passwordControl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return DrAWER();
            }else
              return Container(
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/tf4.jpg'),fit: BoxFit.cover)),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome Back!',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white70),),

                      TextFie(
                        text: 'Email',
                        obsecure: false,
                        pIcon: Icons.email,
                        controller: emailControl,
                      ),
                      TextFie(
                        text: 'Password',
                        obsecure: true,
                        pIcon: Icons.lock,
                        controller: passwordControl,
                      ),
                     ButtonDe(onPressed: signInUser, text: 'Login', colorb: Colors.purple,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have any account?",style: TextStyle(color: Colors.grey[300]),),
                          TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => SignUpScreen()));
                              },
                              child: Text('Register here',style: TextStyle(color: Colors.purpleAccent),)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
          }
      ),
    );
  }
}
