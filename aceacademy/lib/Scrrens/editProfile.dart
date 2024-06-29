import 'package:aceacademy/components/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const EditProfileScreen({Key? key, this.userData}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with existing user data if available
    if (widget.userData != null) {
      _nameController.text = widget.userData!['name'];
      _emailController.text = widget.userData!['email'];
      _schoolController.text = widget.userData!['school'];
      _phoneController.text = widget.userData!['phone'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/tf1.jpg'),fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.heightBox,
            Text('Edit Profile',style: TextStyle(fontSize: 25,color: Colors.white),),
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name',labelStyle: TextStyle(color: Colors.white70,fontSize: 22)),
            ),
            TextFormField(
              style: TextStyle(fontSize: 18,color: Colors.white),
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email',labelStyle: TextStyle(color: Colors.white70,fontSize: 22)),
            ),
            TextFormField(
              style: TextStyle(fontSize: 16,color: Colors.white),
              controller: _schoolController,
              decoration: InputDecoration(labelText: 'School',labelStyle: TextStyle(color: Colors.white70,fontSize: 22)),
            ),
            TextFormField(
              style: TextStyle(fontSize: 16,color: Colors.white),
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone',labelStyle: TextStyle(color: Colors.white70,fontSize: 22)),
            ),
            SizedBox(height: 16.0),
            ButtonDe(
              onPressed: () {
                // Update user details
                Map<String, dynamic> updatedData = {
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'school': _schoolController.text,
                  'phone': _phoneController.text,
                };
                _updateUserDetails(updatedData);
              },
              text: 'Save Changes', colorb: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserDetails(Map<String, dynamic> updatedData) async {
    try {
      // Update user details
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(updatedData);

      // Navigate back to the profile screen
      Navigator.pop(context);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (error) {
      // Handle error
      print('Error updating user details: $error');

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }
}
