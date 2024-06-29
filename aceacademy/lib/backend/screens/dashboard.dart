import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateUserRecentWatch(String courseId, String videoTitle, String timestamp) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userId = user.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Retrieve current recent watch list
    final userData = await userRef.get();
    final recentWatch = List<Map<String, dynamic>>.from(userData.data()?['recentWatch'] ?? []);

    // Add the new video to the recent watch list
    recentWatch.insert(0, {
      'courseId': courseId,
      'title': videoTitle,
      'timestamp': timestamp,
    });

    // Limit the recent watch list to a certain number of entries (e.g., 10)
    if (recentWatch.length > 10) {
      recentWatch.removeLast();
    }

    // Update the recent watch list in Firestore
    await userRef.update({'recentWatch': recentWatch});
  }
}
