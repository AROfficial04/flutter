import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'course_dtails.dart';

class MyCoursesScreen extends StatefulWidget {


  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  String studentId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(studentId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.purple,));
          }
          Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null || !data.containsKey('courses')) {
            return Center(child: Text('No courses enrolled'));
          }
          List<dynamic> courseIds = data['courses'];
          return Container(
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg1.jpg'),fit: BoxFit.cover)),
            child: ListView.builder(
              itemCount: courseIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('courses').doc(courseIds[index]).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: SizedBox(
                          height: 20,width: 20,
                          child: CircularProgressIndicator(color: Colors.purple,strokeWidth: 2,)));
                    }
                    else if (snapshot.hasError ) {
             return Text('Error : ${snapshot.error}');

                    }
                    Map<String, dynamic> ? courseData = snapshot.data!.data() as Map<String, dynamic>?;
                    if (courseData == null) {
                      return Text('Course details not found');
                    }
                    String courseName = courseData['name'];
                    String imageUrl = courseData['imageUrl'];
                    double price = courseData['price'];
                    String time = courseData['time'];
                    String desc = courseData['description'];
                    String cid = courseIds[index];
                    // You can access more course details here if needed
                    return ListTile(
                      title: Text(courseName,style: TextStyle(color: Colors.white),),
                      leading: Image.network('${imageUrl}',width: 50,height: 50,fit: BoxFit.cover,),
                      subtitle: Text('Rs ${price}',style: TextStyle(color: Colors.white70),),
                      trailing: IconButton(onPressed: (){
                        deleteCourse(courseIds[index]);
                      },icon: Icon(Icons.delete,color: Colors.red,),),
                      onTap: () {
                        // Navigate to course details page or perform other actions
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CourseDetails(
                                  imageUrl: imageUrl,
                                  name: courseName,
                                  description: desc,
                                  price: price,
                                  time: time, couid: cid,
                                )));
                        print(cid);
                      },
                      // You can add more details here if needed
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
  void deleteCourse(String courseId) async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Get the document reference for the user
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Update the courses array field in the user document to remove the courseId
      await userRef.update({
        'courses': FieldValue.arrayRemove([courseId]),
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course deleted successfully')),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

}
