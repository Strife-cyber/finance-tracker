import 'dart:convert';

class Accounts {
  final String id;
  final String userId;
  final String name;
  final double salary;

  Accounts({
    required this.id,
    required this.userId,
    required this.name,
    required this.salary,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'salary': salary,
    };
  }

  factory Accounts.fromMap(Map<String, dynamic> map) {
    return Accounts(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      salary: map['salary']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Accounts.fromJson(String source) =>
      Accounts.fromMap(json.decode(source));
}
