import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../provider/post_provider.dart';
import '../widgets/video_player_widget.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<PostProvider>(context).posts;

    return Scaffold(
      backgroundColor: Colors.black, // Dark mode background
      appBar: AppBar(
        title: Text("Uploaded Posts"),
        backgroundColor: Colors.grey[900], // Darker app bar
      ),
      body:
          posts.isEmpty
              ? Center(
                child: Text(
                  "No posts yet.",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return Container(
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display multiple media files
                        if (post.mediaUrls.isNotEmpty)
                          SizedBox(
                            height: 250,
                            child: PageView.builder(
                              itemCount: post.mediaUrls.length,
                              itemBuilder: (context, mediaIndex) {
                                String mediaUrl = post.mediaUrls[mediaIndex];
                                bool isVideo =
                                    mediaUrl.endsWith('.mp4') ||
                                    mediaUrl.endsWith('.mov');

                                return ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child:
                                      isVideo
                                          ? VideoPlayerWidget(
                                            videoPath: mediaUrl,
                                          )
                                          : Image.file(
                                            File(mediaUrl),
                                            height: 250,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Container(
                                                  height: 250,
                                                  color: Colors.grey[800],
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.white54,
                                                      size: 50,
                                                    ),
                                                  ),
                                                ),
                                          ),
                                );
                              },
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.caption,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Posted by: ${post.username}",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.comment,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}

/// **🎥 VideoPlayer Widget**
class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  const VideoPlayerWidget({Key? key, required this.videoPath})
    : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {}); // Update the UI when video is ready
        _controller.setLooping(true); // Loop video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
            ),
          ],
        )
        : Container(
          height: 250,
          color: Colors.black,
          child: Center(child: CircularProgressIndicator()),
        );
  }
}
