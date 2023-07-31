class VideoModel {
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String createrUid;
  final int likes;
  final int comments;
  final int createdAt;

  VideoModel({
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.createrUid,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });
}
