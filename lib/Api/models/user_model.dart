class UserModel {
  final int id;
  final String? name;
  final String? email;
  final String? phone;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      emailVerifiedAt: json['email_verified_at']?.toString(),
      phoneVerifiedAt: json['phone_verified_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'email_verified_at': emailVerifiedAt,
        'phone_verified_at': phoneVerifiedAt,
      };
}
