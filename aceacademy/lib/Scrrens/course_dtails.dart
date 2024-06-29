import 'package:aceacademy/Scrrens/profile.dart';
import 'package:aceacademy/Scrrens/videoscreen.dart';
import 'package:aceacademy/components/buttons.dart';
import 'package:aceacademy/components/glass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CourseDetails extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final double price;
  final String time;
  final String couid;

  const CourseDetails({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
    required this.time,
    required this.couid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/tf1.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 40, bottom: 15),
                height: 200,
                width: double.infinity,
                child: Image.network('${imageUrl}', fit: BoxFit.cover),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                child: FrostedGlassB(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text('${description}'),
                      Text('Duration : ${time}'),
                      Text('Rating : 4.3'),
                      Text('Price : ${price}'),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                height: 500,
                child: FrostedGlassB(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 0,
                            indicatorPadding:
                                EdgeInsets.only(bottom: 5, top: 5),
                            indicatorColor: Colors.transparent,
                            indicator: BoxDecoration(
                                color: Colors.purple.shade100.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12)),
                            unselectedLabelColor: Colors.grey,
                            labelColor: Colors.white,
                            labelStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            unselectedLabelStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                            tabs: [
                              Tab(
                                text: 'Videos',
                              ),
                              Tab(
                                text: 'Notes',
                              )
                            ]),
                        Expanded(
                            child: TabBarView(children: [
                          VideosList(couid: couid),
                          NotesList(couid: couid),
                        ]))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue.withOpacity(0.4),
                border: Border.all(color: Vx.blue200)),
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                try {
                  // Get the current user's ID
                  String userId = FirebaseAuth.instance.currentUser!.uid;

                  // Get the document reference for the user
                  DocumentReference userRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId);

                  // Update the course array field in the user document
                  await userRef.update({
                    'courses': FieldValue.arrayUnion([couid]),
                    // courseId is the ID of the course to add
                  });

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Enrolled successfully')),
                  );
                } catch (e) {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: Text(
                'Enroll Now',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VideoListItem extends StatefulWidget {
  final String videoLink;

  const VideoListItem({Key? key, required this.videoLink}) : super(key: key);

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  late String videoTitle = '';
  late String thumbnailUrl = '';

  @override
  void initState() {
    super.initState();
    fetchVideoMetadata();
  }

  void fetchVideoMetadata() async {
    var yt = YoutubeExplode();
    try {
      var video = await yt.videos.get(widget.videoLink);
      setState(() {
        videoTitle = video.title;
        thumbnailUrl =
            'https://img.youtube.com/vi/${video.id}/maxresdefault.jpg';
      });
    } catch (e) {
      print('Error fetching video metadata: $e');
    } finally {
      yt.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return thumbnailUrl.isNotEmpty && videoTitle.isNotEmpty
        ? ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Image.network(
                thumbnailUrl,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(videoTitle),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YouTubePlayerWidget(
                    videoUrl: widget.videoLink,
                  ),
                ),
              );
              try {
                // Get the current user's ID
                String userId = FirebaseAuth.instance.currentUser!.uid;

                // Get the document reference for the user
                DocumentReference userRef =
                    FirebaseFirestore.instance.collection('users').doc(userId);
                var userData = await userRef.get();
                List<dynamic> recentVideos = userData['recent'] ?? [];

// Add the new video link to the "recent" array
                recentVideos.add(widget.videoLink);

// Check if the length of the "recent" array exceeds the maximum allowed length
                const maxRecentVideos = 10;

                Timestamp timestamp = Timestamp.now();
                DateTime dateTime = timestamp.toDate();
                String formattedDateTime =
                    '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';

                // Update the course array field in the user document
                await userRef.update({
                  'recent': FieldValue.arrayUnion([widget.videoLink]),
                  'timestamp': FieldValue.arrayUnion([formattedDateTime]),
                });
                // print('recent videis length ${recentVideos.length}');
                if (recentVideos.length > maxRecentVideos) {
                  // Remove the oldest item from the array
                  recentVideos.removeAt(0);
                }

                // Show a success message
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Enrolled successfully')),
                // );
              } catch (e) {
                // Show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
          )
        : SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
  }
}

class VideosList extends StatelessWidget {
  final String couid;

  const VideosList({super.key, required this.couid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc(couid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SizedBox(width: 50, child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final courseData = snapshot.data?.data();
        if (courseData == null || courseData is! Map) {
          return Center(child: Text('Course not found'));
        }

        final List<dynamic>? videos = courseData['videos'];
        if (videos == null) {
          return Center(child: Text('No videos found'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final videoUrl = videos[index];
            return Column(
              children: [
                VideoListItem(videoLink: videoUrl),
                if (index != videos.length + 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withOpacity(0.4),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class NotesList extends StatelessWidget {
  final String couid;

  const NotesList({super.key, required this.couid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc(couid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SizedBox(width: 50, child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final courseData = snapshot.data?.data();
        if (courseData == null || courseData is! Map) {
          return Center(child: Text('Course not found'));
        }

        final List<dynamic>? notes = courseData['notes'];
        if (notes == null) {
          return Center(child: Text('No videos found'));
        }

        return ListView.builder(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final notesList = notes[index];
            return Column(
              children: [
                ListTile(
                  title: Text(notesList),
                ),
                if (index != notesList.length - 1) Divider(),
              ],
            );
          },
        );
      },
    );
  }
}
