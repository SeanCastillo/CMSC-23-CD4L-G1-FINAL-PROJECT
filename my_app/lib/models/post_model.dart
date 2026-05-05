class PantryPost {
  final String id;
  final String title;
  final String description;
  final DateTime expiration;
  final List<String> tags;
  final String imagePath;

  PantryPost({
    required this.id,
    required this.title,
    required this.description,
    required this.expiration,
    required this.tags,
    required this.imagePath,
  });
}