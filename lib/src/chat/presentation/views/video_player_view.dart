import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({required this.videoURL, super.key});

  final String videoURL;

  static const id = 'video-player';

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late CachedVideoPlayerController controller;

  bool get isPlaying => controller.value.isPlaying;

  @override
  void initState() {
    controller = CachedVideoPlayerController.network(widget.videoURL)
      ..initialize().then((_) => controller.setVolume(1));
    controller
      ..play()
      // seeker listener
      ..addListener(() {
        if (!mounted) return;
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    controller
      ..removeListener(() {
        if (!mounted) return;
        setState(() {});
      })
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CachedVideoPlayer(controller),
            ),
          ),
          if (!controller.value.isBuffering)
            Center(
              child: IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await controller.pause();
                  } else {
                    await controller.play();
                  }
                  setState(() {});
                },
                icon: Opacity(
                  opacity: 0.5,
                  child: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 50,
                  ),
                ),
              ),
            ),
          // progress indicator
          if (controller.value.isBuffering)
            const Center(child: CircularProgressIndicator()),

          // slider seek to control video
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Slider(
                value: controller.value.position.inSeconds.toDouble(),
                max: controller.value.duration.inSeconds.toDouble(),
                onChanged: (value) {
                  controller.seekTo(Duration(seconds: value.toInt()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
