import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 1)
class ExpenseModel {
  ExpenseModel(
      {required this.amount, required this.date, required this.description});

  @HiveField(0)
  double amount;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String description;

  factory ExpenseModel.fromJson(Map<dynamic, dynamic> json) => ExpenseModel(
      amount: double.parse(json["amount"]),
      date: DateTime.parse(json["date"]),
      description: json["description"]);

  Map<String, dynamic> toJson() {
    return {
      'amount': amount.toString(),
      'date': date.toString(),
      'description': description,
    };
  }
}
