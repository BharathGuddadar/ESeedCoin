import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/post_provider.dart';
import '../models/post_model.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'post_screen.dart';
import 'package:video_player/video_player.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  List<File> _selectedMedia = []; // Stores both images & videos
  List<bool> _isVideo = []; // Tracks if media is a video
  VideoPlayerController? _videoController;

  Future<void> _pickMedia(bool isVideo) async {
    final ImagePicker picker = ImagePicker();
    if (isVideo) {
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedMedia.add(File(pickedFile.path));
          _isVideo.add(true);
          _videoController = VideoPlayerController.file(File(pickedFile.path))
            ..initialize().then((_) => setState(() {}));
        });
      }
    } else {
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _selectedMedia.addAll(pickedFiles.map((file) => File(file.path)));
          _isVideo.addAll(List.generate(pickedFiles.length, (_) => false));
        });
      }
    }
  }

  void _postContent() {
    if (_selectedMedia.isEmpty) return;

    final newPost = PostModel(
      id: Uuid().v4(),
      userId: "user_123",
      username: "burra",
      caption:
          _captionController.text.isNotEmpty ? _captionController.text : "",
      mediaUrls: _selectedMedia.map((file) => file.path).toList(),
      timestamp: DateTime.now(),
    );

    Provider.of<PostProvider>(context, listen: false).addPost(
      newPost.userId,
      newPost.username,
      newPost.caption,
      newPost.mediaUrls,
    );

    _captionController.clear();
    _selectedMedia = [];
    _isVideo = [];
    _videoController?.dispose();
    _videoController = null;

    Future.delayed(Duration(milliseconds: 200), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create a Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                hintText: "Add a caption (optional)...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickMedia(false),
                  icon: Icon(Icons.image),
                  label: Text("Select Images"),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _pickMedia(true),
                  icon: Icon(Icons.videocam),
                  label: Text("Select Video"),
                ),
              ],
            ),
            if (_selectedMedia.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedMedia.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child:
                          _isVideo[index]
                              ? _videoController != null &&
                                      _videoController!.value.isInitialized
                                  ? AspectRatio(
                                    aspectRatio:
                                        _videoController!.value.aspectRatio,
                                    child: VideoPlayer(_videoController!),
                                  )
                                  : Icon(
                                    Icons.videocam,
                                    size: 100,
                                    color: Colors.white,
                                  )
                              : Image.file(_selectedMedia[index], height: 150),
                    );
                  },
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _postContent, child: Text("Post")),
          ],
        ),
      ),
    );
  }
}
