import 'package:aceacademy/backend/admin.dart';
import 'package:aceacademy/components/buttons.dart';
import 'package:aceacademy/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminLogin extends StatefulWidget {

  @override

  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late SharedPreferences _prefs;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _loggedIn = _prefs.getBool('loggedIn') ?? false;
    });
  }

  Future<void> _login() async {
    // Perform login validation (e.g., check username and password)
    // For temporary login, let's assume it's successful if both fields are non-empty
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      if (_usernameController.text == 'admin7' &&
          _passwordController.text == 'ad1234') {
        await _prefs.setBool('loggedIn', true);
        setState(() {
          _loggedIn = true;
        });

        // Navigate to another page after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()), // Replace HomePage with the desired page
        );
      } else {
        VxToast.show(context, msg: 'Wrong Credentials');
      }
    }
  }

  Future<void> _logout() async {
    await _prefs.setBool('loggedIn', false);
    setState(() {
      _loggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _loggedIn ? AdminPage() : Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('A D M I N',style: TextStyle(color: Colors.purple, fontSize: 40,),),
            50.heightBox,
            TextFie(text: 'Admin Id', obsecure: false, pIcon: Icons.supervised_user_circle, controller: _usernameController),
              TextFie(text: 'Password', obsecure: true, pIcon: Icons.password, controller: _passwordController),

              SizedBox(height: 10),
             ButtonDe(onPressed: _login, text: 'Proceed', colorb: Vx.blue700,)
            ],
          ),
      ),

    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}