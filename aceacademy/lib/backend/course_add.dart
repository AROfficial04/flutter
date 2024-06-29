import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  final CollectionReference _coursesCollection = FirebaseFirestore.instance.collection('courses');

  Future<void> addCourse({
    required String name,
    required String time,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
    required List videos,
    required List notes,
  }) async {
    try {
      await _coursesCollection.add({
        'name': name,
        'time': time,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'videos' : videos,
        'category' : category,
        'notes' : notes,
      });
    } catch (e) {
      print('Error adding course: $e');
      throw e; // You can handle the error according to your application's logic
    }
  }
}

class AddCourseScreen extends StatefulWidget {
  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _cateController = TextEditingController();


  final CourseService _courseService = CourseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _cateController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _courseService.addCourse(
                    name: _nameController.text,
                    category: _cateController.text,
                    time: _timeController.text,
                    description: _descriptionController.text,
                    price: double.parse(_priceController.text),
                    imageUrl: _imageUrlController.text, videos: [], notes: [],
                  ).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Course added successfully!')),
                    );
                    _nameController.clear();
                    _timeController.clear();
                    _descriptionController.clear();
                    _cateController.dispose();
                    _priceController.clear();
                    _imageUrlController.clear();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding course: $error')),
                    );
                  });
                },
                child: Text('Add Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
