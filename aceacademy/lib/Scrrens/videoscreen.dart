import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerWidget extends StatelessWidget {
  final String videoUrl;

  const YouTubePlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: _extractVideoId(videoUrl),
            flags: YoutubePlayerFlags(
              autoPlay: true,
              mute: false,

            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.purpleAccent,
          progressColors: ProgressBarColors(
            playedColor: Colors.deepPurple,
            handleColor: Colors.purple,
          ),
        ),
      ),
    );
  }

  String _extractVideoId(String videoUrl) {
    final uri = Uri.parse(videoUrl);
    if (uri.host == 'youtu.be') {
      return uri.pathSegments.first;
    } else {
      return uri.queryParameters['v']!;
    }
  }
}
