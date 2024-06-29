import 'package:aceacademy/backend/addvideos.dart';
import 'package:aceacademy/backend/course_add.dart';
import 'package:aceacademy/backend/signupadmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [IconButton(onPressed: (){

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminLogin()));
        }, icon: Icon(Icons.logout,size: 20,))],
      ),
      drawer: Drawer(
width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 150,
              child: DrawerHeader(

                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Center(
                  child: Text(
                    'A D M I N',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,fontWeight: FontWeight.w100
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
                // Navigate to the dashboard page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()), // Replace HomePage with the desired page
                );
              },
            ),
            ListTile(
              title: Text('Add Courses'),
              onTap: () {
                // Navigate to the add courses page
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddCourseScreen())
                );
              },
            ),
            ListTile(
              title: Text('Add Videos'),
              onTap: () {
                // Navigate to the add videos page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVideos()), // Replace HomePage with the desired page
                );
              },
            ),
          ],
        ),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'User Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<DataRow> rows = snapshot.data!.docs.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  Map<String, dynamic> userData = entry.value.data() as Map<String, dynamic>;
                  int coursesCount = (userData['courses'] as List<dynamic>?)?.length ?? 0;
                  int recentCount = (userData['recent'] as List<dynamic>?)?.length ?? 0;


                  return DataRow(
                    cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(userData['name'] ?? '')),
                      DataCell(Text(userData['email'] ?? '')),
                      DataCell(Text(userData['age'] != null ? userData['age'].toString() : '')),
                      DataCell(Text(userData['phone'] ?? '')),
                      DataCell(Text(userData['school'] ?? '')),
                      DataCell(Text(coursesCount.toString())),
                      DataCell(Text(recentCount.toString())),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete,color: Colors.red,),
                          onPressed: () {
                            showConfirmationDialog(context, snapshot.data!.docs[entry.key].id,'users');
                          },
                        ),
                      ),
                    ],
                  );
                }).toList();
        
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('S No.')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Age')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('School')),
                      DataColumn(label: Text('Courses')),
                      DataColumn(label: Text('Recent watches')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: rows,
                  ),
                );
              },
            ),
           
            SizedBox(height: 10),
            SizedBox(height: 20),
            Text(
              'Courses Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 300, // Fixed height to prevent overflow
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('courses').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  List<DataRow> rows = snapshot.data!.docs.asMap().entries.map((entry) {
                    int index = entry.key + 1; // Adjust index calculation
                    DocumentSnapshot courseSnapshot = entry.value;
                    String courseId = courseSnapshot.id;
                    Map<String, dynamic> courseData = courseSnapshot.data() as Map<String, dynamic>;
                    return DataRow(
                      cells: [
                        DataCell(Text(index.toString())),
                        DataCell(Text(courseId)),
                        DataCell(Text(courseData['name'] ?? '')),
                        DataCell(Text(courseData['category'] ?? '')),
                        DataCell(Text(courseData['description'] ?? '')),
                        DataCell(Image.network('${courseData['imageUrl']}' ?? '',height: 50,width: 50,)),
                        DataCell(Text(' \u{20B9}${courseData['price']}' ?? '')),
                        DataCell(Text(courseData['time'] ?? '')),
                        DataCell(Text((courseData['videos'] as List<dynamic>?)?.length.toString() ?? '0')),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete,color: Colors.red,),
                            onPressed: () {
                              showConfirmationDialog(context, snapshot.data!.docs[entry.key].id,'courses');
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList();
        
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('C No.')),
                        DataColumn(label: Text('Course ID')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Image')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Time')),
                        DataColumn(label: Text('Videos Count')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: rows,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
  Future<void> showConfirmationDialog(BuildContext context, String docId, String collection) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog is not dismissible by tapping outside
      builder: (BuildContext context) {

        return collection=='users'? AlertDialog(
          title: Text('Delete User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this user?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the function to delete the user
                deleteUserData(docId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        ): AlertDialog(
          title: Text('Delete Course'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this course?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the function to delete the user
                deleteCourseData(docId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        ) ;
      },
    );
  }

  void deleteUserData(String userId) {

    FirebaseFirestore.instance.collection('users').doc(userId).delete()
        .then((_) {
      // Document successfully deleted
      print('User document deleted successfully');
    })
        .catchError((error) {
      // Error handling
      print('Error deleting user document: $error');
    });
  }


  void deleteCourseData(String courseId) async {
    FirebaseFirestore.instance.collection('courses').doc(courseId).delete()
        .then((_) {
      // Document successfully deleted
      print('User document deleted successfully');
    })
        .catchError((error) {
      // Error handling
      print('Error deleting user document: $error');
    });
  }

}
