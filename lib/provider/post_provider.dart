import 'package:flutter/material.dart';
import '../models/post_model.dart';
import 'package:uuid/uuid.dart';

class PostProvider with ChangeNotifier {
  List<PostModel> _posts = [];

  List<PostModel> get posts => _posts;

  void addPost(
    String userId,
    String username,
    String caption,
    List<String> mediaUrls,
  ) {
    final newPost = PostModel(
      id: Uuid().v4(),
      userId: userId,
      username: username,
      caption: caption,
      mediaUrls: mediaUrls, // Store multiple media files
      timestamp: DateTime.now(),
    );

    _posts.insert(0, newPost); // Add to top (latest post first)
    notifyListeners();
  }
}
