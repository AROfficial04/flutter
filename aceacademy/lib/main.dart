import 'package:aceacademy/authentication/signup.dart';
import 'package:aceacademy/components/textfield.dart';
import 'package:aceacademy/firebase_options.dart';
import 'package:aceacademy/Scrrens/home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Scrrens/drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-1488440149411032/3968053561');
  await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
     iconButtonTheme: IconButtonThemeData(style: ButtonStyle(iconColor:MaterialStateProperty.all(Colors.white70))),
     textTheme: GoogleFonts.rubikTextTheme() ,
        primarySwatch: Colors.deepPurple
      ),
      initialRoute: '/',routes: {
        '/home' : (context)=> HomeScreen(),
      '/drawer' : (context) => DrAWER(),
    },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator(color: Colors.blueAccent,);
          }else if(snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          }
          else if(snapshot.hasData){
            return DrAWER();
          }else{
            return SignUpScreen();
          }
        },
      ),
    );
  }
}