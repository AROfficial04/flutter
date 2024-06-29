import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'course_dtails.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(

          children: [
            50.heightBox,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchText = '';
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                key: UniqueKey(), // Add a key
                stream: FirebaseFirestore.instance.collection('courses').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final docs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name'].toString().toLowerCase();
                    final description = _truncateDescription(data['description'], 5);
                    return name.contains(_searchText.toLowerCase()) ||
                        description.contains(_searchText.toLowerCase());
                  });

                  return ListView(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final imageUrl = data['imageUrl'];
                      final name = data['name'];
                      final description = data['description'];
                      final price = data['price'];
                      final time = data['time'];
                      final couid = doc.id; // Use document ID here

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetails(
                                imageUrl: imageUrl,
                                name: name,
                                description: description,
                                price: price,
                                time: time,
                                couid: couid,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(data['name']),
                          subtitle: Text(_truncateDescription(data['description'], 20)),
                          trailing: Text(data['price'].toString()),
                          leading: Image.network('${data['imageUrl']}', height: 50, width: 50, fit: BoxFit.cover,),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _truncateDescription(String description, int maxLength) {
    if (description.length <= maxLength) {
      return description;
    }
    return '${description.substring(0, maxLength)}...';
  }
}
