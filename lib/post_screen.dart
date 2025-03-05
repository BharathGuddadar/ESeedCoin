import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/post_provider.dart';
import '../models/post_model.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _captionController = TextEditingController();
  List<File> _selectedMedia = []; // Store multiple images

  Future<void> _pickImage() async {
    final pickedFiles =
        await ImagePicker().pickMultiImage(); // Pick multiple images

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedMedia = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  void _postContent() {
    if (_selectedMedia.isEmpty) return; // Ensure at least one image is selected

    final newPost = PostModel(
      id: Uuid().v4(),
      userId: "user_123",
      username: "burra",
      caption:
          _captionController.text.isNotEmpty ? _captionController.text : "",
      mediaUrls:
          _selectedMedia
              .map((file) => file.path)
              .toList(), // Store multiple images
      timestamp: DateTime.now(),
    );

    Provider.of<PostProvider>(context, listen: false).addPost(
      newPost.userId,
      newPost.username,
      newPost.caption,
      newPost.mediaUrls, // Pass list of media
    );

    // Reset fields after posting
    setState(() {
      _selectedMedia = [];
      _captionController.clear();
    });

    // Go back to home screen
    Navigator.pop(context);
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
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text("Select Images"),
            ),
            if (_selectedMedia.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedMedia.length,
                  itemBuilder:
                      (context, index) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.file(_selectedMedia[index], height: 150),
                      ),
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
