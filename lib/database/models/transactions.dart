import 'dart:convert';

class Transactions {
  // A user cannot make a transaction if he did not make a budget yet
  final String id;
  final String userId;
  final String accountId;
  final String categoryId;
  final double amount;
  final DateTime made;
  final String description;

  Transactions({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.made,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'accountId': accountId,
      'categoryId': categoryId,
      'amount': amount,
      'made': made.millisecondsSinceEpoch,
      'description': description,
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id'] ?? '',
      userId: map['userid'] ?? '',
      accountId: map['accountid'] ?? '',
      categoryId: map['categoryid'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      made: DateTime.fromMillisecondsSinceEpoch(map['made']),
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Transactions.fromJson(String source) =>
      Transactions.fromMap(json.decode(source));
}
