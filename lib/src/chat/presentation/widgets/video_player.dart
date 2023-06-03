import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/src/chat/presentation/views/video_player_view.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({required this.videoURL, super.key});

  final String videoURL;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late CachedVideoPlayerController videoController;

  @override
  void initState() {
    videoController = CachedVideoPlayerController.network(widget.videoURL)
      ..initialize();
    super.initState();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoController),
          Center(
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  VideoPlayerView.id,
                  arguments: widget.videoURL,
                );
              },
              icon: const Icon(Icons.play_circle),
            ),
          )
        ],
      ),
    );
  }
}
