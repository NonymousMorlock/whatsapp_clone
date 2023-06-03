import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/material.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({required this.audioURL, super.key});

  final String audioURL;

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  final audioPlayer = ap.AudioPlayer();
  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints(minWidth: 100),
      icon: Icon(
        audioPlayer.state == ap.PlayerState.playing
            ? Icons.pause_circle
            : Icons.play_circle,
      ),
      onPressed: () async {
        if (audioPlayer.state == ap.PlayerState.playing) {
          await audioPlayer.pause();
        } else {
          await audioPlayer.play(ap.UrlSource(widget.audioURL));
        }
      },
    );
  }
}
