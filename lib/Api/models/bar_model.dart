class Bar {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String? description;

  Bar({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.description,
  });

  factory Bar.fromJson(Map<String, dynamic> json) {
    return Bar(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone']?.toString() ?? '',
      description: json['description'],
    );
  }
}