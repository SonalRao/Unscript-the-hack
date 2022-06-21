class User {
  final String imagePath;
  final String name;
  final String email;
  final String memberDuration;
  final String password;

  const User(
    {
    required this.imagePath,
    required this.name,
    required this.email,
    required this.memberDuration,
    required this.password,
  });
}
