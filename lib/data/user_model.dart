class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' atau 'user'

  UserModel({required this.id, required this.name, required this.email, required this.role});

  factory UserModel.fromFakeLogin(String email) {
    return UserModel(
      id: '1',
      name: 'Takmir Masjid Ham',
      email: email,
      role: 'admin',
    );
  }
}
