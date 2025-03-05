class PostModel {
  final String id;
  final String userId;
  final String username;
  final String caption;
  final List<String> mediaUrls; // Now supports multiple media files
  final DateTime timestamp;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.caption,
    required this.mediaUrls, // Updated field to store multiple media files
    required this.timestamp,
  });
}
