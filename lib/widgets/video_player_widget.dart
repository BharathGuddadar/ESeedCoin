import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  const VideoPlayerWidget({Key? key, required this.videoPath})
    : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (!File(widget.videoPath).existsSync()) {
        print("File not found: ${widget.videoPath}");
        return;
      }

      _controller = VideoPlayerController.file(File(widget.videoPath))
        ..initialize()
            .then((_) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            })
            .catchError((error) {
              print("Error initializing video: $error");
            });

      _controller.setLooping(true);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
          height: 250,
          color: Colors.black,
          child: Center(child: CircularProgressIndicator()),
        )
        : GestureDetector(
          onTap: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              if (!_controller.value.isPlaying)
                Icon(Icons.play_arrow, color: Colors.white, size: 50),
            ],
          ),
        );
  }
}
