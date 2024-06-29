import 'package:aceacademy/components/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AddVideos extends StatefulWidget {
  const AddVideos({super.key});

  @override
  State<AddVideos> createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> {
  String? _selectedCourseName;

  TextEditingController videoControl = TextEditingController();
  TextEditingController notesControl = TextEditingController();

  @override
  void dispose() {
    videoControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Videos'),
      ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/tf2.jpg'),fit: BoxFit.cover)),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('courses').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                List<String> courseNames = [];
                if (snapshot.hasData) {
                  courseNames = snapshot.data!.docs.map((doc) => doc['name']).cast<String>().toList();
                } else {
                  // Handle the case when snapshot.data is null or not containing the expected data structure
                  // For example, you can show a placeholder text or return an empty list
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DropdownButton<String>(

                    value: _selectedCourseName,
                    items: courseNames.map<DropdownMenuItem<String>>((String name) {
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCourseName = newValue;
                      });
                    },
                  ),
                );
              },
            ),
            TextFie(
              text: 'Add video link',
              obsecure: false,
              pIcon: Icons.video_camera_back,
              controller: videoControl,
            ),
            TextFie(
              text: 'Add Notes',
              obsecure: false,
              pIcon: Icons.note_add,
              controller: notesControl,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: () async {
                  try {
                    // Get the course document reference
                    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('courses').where('name', isEqualTo: _selectedCourseName).get();
                    String courseId = querySnapshot.docs[0].id;

                    // Update the videos array field in the course document
                    DocumentReference courseRef = FirebaseFirestore.instance.collection('courses').doc(courseId);
                    await courseRef.update({
                      'videos': FieldValue.arrayUnion([videoControl.text]),
                    });

                    await courseRef.update({
                      'notes': FieldValue.arrayUnion([notesControl.text]),
                    });
                    videoControl.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text('ADD NOW',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
