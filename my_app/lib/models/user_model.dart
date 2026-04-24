class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final bool isVerified;
  final List<String> tags;
  final String? profileImageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.role = 'community_member',
    this.isVerified = false,
    this.tags = const [],
    this.profileImageUrl,
  });
}