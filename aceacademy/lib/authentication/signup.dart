import 'package:aceacademy/authentication/login.dart';
import 'package:aceacademy/backend/signupadmin.dart';
import 'package:aceacademy/components/buttons.dart';
import 'package:aceacademy/components/color.dart';
import 'package:aceacademy/components/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameControl = TextEditingController();
  TextEditingController emailControl = TextEditingController();
  TextEditingController ageControl = TextEditingController();
  TextEditingController insControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();
  TextEditingController phoneControl = TextEditingController();

  Future<void> signUpUser() async {
    String name = nameControl.text;
    String email = emailControl.text;
    String phone = phoneControl.text;
    String age = ageControl.text;
    String school = insControl.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email, password: passwordControl.text);

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'phone': phone,
        'age': age,
        'email': email,
        'school': school,
        'courses': [],
        'recent' :[],
        'timestamp':[]
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  void dispose() {
    emailControl.dispose();
    passwordControl.dispose();
    nameControl.dispose();
    phoneControl.dispose();
    insControl.dispose();
    ageControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: double.infinity,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/tf4.jpg'),fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Text('Create Your Account Today!',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white70),),
                TextFie(
                  text: 'Full Name',
                  obsecure: false,
                  pIcon: Icons.person,
                  controller: nameControl,
                ),
                TextFie(
                  text: 'Phone Number',
                  obsecure: false,
                  pIcon: Icons.phone,
                  controller: phoneControl,
                ),
                TextFie(
                  text: 'Dob',
                  obsecure: false,
                  pIcon: Icons.calendar_month,
                  controller: ageControl,
                ),
                TextFie(
                  text: 'Institute',
                  obsecure: false,
                  pIcon: Icons.school,
                  controller: insControl,
                ),
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
                ButtonDe(text: 'Register', onPressed: signUpUser, colorb: Colors.purple,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',style: TextStyle(color: Colors.grey[300]),),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: Text('Login',style: TextStyle(color: Colors.purpleAccent),)),
                  ],
                ),
                TextButton(

                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AdminLogin()));
                    },

                    child: Text('Admin?')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
