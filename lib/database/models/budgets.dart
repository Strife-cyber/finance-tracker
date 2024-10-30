import 'dart:convert';

class Budgets {
  final String id;
  final String userId;
  final String categoryId;
  final double amount;
  final DateTime created;

  Budgets({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.created,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'categoryId': categoryId,
      'amount': amount,
      'created': created.millisecondsSinceEpoch,
    };
  }

  factory Budgets.fromMap(Map<String, dynamic> map) {
    return Budgets(
      id: map['id'] ?? '',
      userId: map['userid'] ?? '',
      categoryId: map['categoryid'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      created: DateTime.fromMillisecondsSinceEpoch(map['created']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Budgets.fromJson(String source) =>
      Budgets.fromMap(json.decode(source));
}
