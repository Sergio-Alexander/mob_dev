class User {
  String id;
  String username;
  int healthPoints;

  User({
    required this.id,
    required this.username,
    required this.healthPoints,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Username': username,
      'Health Points': healthPoints,
    };
  }
}
