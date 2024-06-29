import 'package:aceacademy/Scrrens/course_dtails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String name;
  final String time;
  final String description;
  final double price;
  final String imageUrl;

  Course({
    required this.name,
    required this.time,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('courses').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg1.jpg'),fit: BoxFit.cover)),
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot course = snapshot.data!.docs[index];
                String cid = course.id;
                return ListTile(
                  leading: Image.network(
                    course['imageUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(course['name'],style: TextStyle(color: Colors.white),),
                  subtitle: Text('Rs ${course['price']}',style: TextStyle(color: Colors.white70),),
                  trailing: Text('${course['time']}',style: TextStyle(color: Colors.white54),),
                  onTap: () {
                    // Navigate to course details page or perform other actions
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CourseDetails(
                                  imageUrl: course['imageUrl'],
                                  name: course['name'],
                                  description: course['description'],
                                  price: course['price'],
                                  time: course['time'], couid: cid,
                                )));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
