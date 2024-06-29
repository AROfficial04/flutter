import 'package:aceacademy/components/stack_box.dart';
import 'package:aceacademy/Scrrens/videoscreen.dart';
import 'package:aceacademy/components/buttons.dart';
import 'package:aceacademy/components/categorybtn.dart';
import 'package:aceacademy/components/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../components/frostedglass.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _tabTitles = ['10th', "12th", 'Btech', 'Coding'];
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  List<String> images = [
    'https://images.pexels.com/photos/630773/forest-autumn-trees-lane-630773.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/464334/pexels-photo-464334.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/1796732/pexels-photo-1796732.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
  ];
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg1.jpg'),fit: BoxFit.cover)),
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                Map<String, dynamic>? userData = snapshot.data?.data();
                final List<dynamic> videos = userData!['recent'];
                String fullName = userData['name'];
                List<String> nameParts = fullName.split(' ');
                String firstName = nameParts.first;

                return Container(
                  height: double.infinity,
                  width: double.infinity,

                decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg1.jpg'),fit: BoxFit.cover)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: FrostedGlass(
                            chilD: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        'Hi , ${firstName}',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[100]),
                                      ),
                                      SizedBox(
                                          width: 220,
                                          child: Text(
                                            'toggle the display of search filters toggle the display of search filters ',
                                            style: TextStyle(color: Colors.grey[200]),
                                          )),
                                    ],
                                  ),

                                InkWell(
                                    child: Image.asset(
                                  'assets/images/pro1.png',
                                  height: 70,
                                ))
                              ],
                            ), sx: 0, sy: 0, enaborder: false,
                          ),
                        ),
                        //     CarouselSlider.builder(itemCount: images.length, itemBuilder: ( BuildContext context,int index,int view){
                        // return  ClipRRect(
                        //
                        //     borderRadius: BorderRadius.circular(12),
                        //     child: Image.network(
                        //       images[index],
                        //       fit: BoxFit.fill,
                        //     ));
                        //     }, options: CarouselOptions(
                        //
                        //       autoPlay: true,
                        //       height: 200,
                        //       enlargeCenterPage: true
                        //     )),

                        videos.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recent',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70),
                                  ).box.padding(EdgeInsets.only(left: 20)).make(),
                                  CarouselSlider.builder(

                                      itemCount: videos.length,
                                      itemBuilder: (context, index, _) {
                                        final videoUrl =
                                            videos.reversed.toList()[index];
                                        return RecentWatch(videoLinks: videoUrl);
                                      },
                                      options: CarouselOptions(
                                          autoPlay: false,
                                          enlargeCenterPage: false,
                                          enableInfiniteScroll: false)),
                                ],
                              )
                            : SizedBox(),
                        Text(
                          'Categories',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70),
                        ).box.padding(EdgeInsets.only(left: 20)).make(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 8),
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),

                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1,crossAxisSpacing: 5,mainAxisSpacing: 5,
                            children: [
                              FrostedGlass(chilD: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               
                                children: [
                                  Icon(Icons.class_,size: 45,color: Colors.white,),
                                  Text('10th CBSE & CGBSE',style: TextStyle(color: Colors.white70,fontSize: 18),),
                                ],
                              ), sx: 0, sy: 0, enaborder: false,),  FrostedGlass(chilD: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               
                                children: [
                                  Icon(Icons.science_outlined,size: 45,color: Colors.white,),
                                  Text('12th CBSE & CGBSE',style: TextStyle(color: Colors.white70,fontSize: 18),),
                                ],
                              ), sx: 0, sy: 0, enaborder: false,),  FrostedGlass(chilD: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               
                                children: [
                                  Icon(Icons.school_sharp,size: 45,color: Colors.white,),
                                  Text('BTech CSE Only',style: TextStyle(color: Colors.white70,fontSize: 18),),
                                ],
                              ), sx: 0, sy: 0, enaborder: false,),  FrostedGlass(chilD: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               
                                children: [
                                  Icon(Icons.code,size: 45,color: Colors.white,),
                                  Text('Programming',style: TextStyle(color: Colors.white70,fontSize: 18),),
                                ],
                              ), sx: 0, sy: 0, enaborder: false,),


                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
      floatingActionButton: Container(
height: 70,width: 70,
          decoration: BoxDecoration(

              color: Colors.indigo.withOpacity(0.5),
            borderRadius: BorderRadius.circular(100)
          ),
          child: IconButton(onPressed: (){}, icon: Icon(Icons.message_outlined,size: 30,color: Colors.white,))),
    );
  }
}

class RecentWatch extends StatefulWidget {
  final String videoLinks;

  const RecentWatch({Key? key, required this.videoLinks}) : super(key: key);

  @override
  _RecentWatchState createState() => _RecentWatchState();
}

class _RecentWatchState extends State<RecentWatch> {
  late String videoTitle = '';
  late String thumbnailUrls = '';

  @override
  void initState() {
    super.initState();
    fetchVideoMetadata();
  }

  void fetchVideoMetadata() async {
    var yt = YoutubeExplode();
    try {
      var video = await yt.videos.get(widget.videoLinks);
      setState(() {
        videoTitle = video.title;
        thumbnailUrls =
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
    return thumbnailUrls.isNotEmpty
        ? Container(
      // height: 10,width: 50,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.network(
              thumbnailUrls,
              width: double.infinity,
              height: 50,
              fit: BoxFit.cover,
            ),
          )
        : Center(
            child: SizedBox(
                height: 45, width: 45, child: CircularProgressIndicator()));
  }
}
