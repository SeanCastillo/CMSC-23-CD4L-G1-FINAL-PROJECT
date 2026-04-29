class ItemModel {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final String imageUrl;
  final DateTime expirationDate;
  final String status;
  final DateTime createdAt;

  // represents food item posted by user
  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.imageUrl,
    required this.expirationDate,
    required this.status,
    required this.createdAt,
  });
}