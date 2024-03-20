import 'dart:convert';

import 'package:expense_tracker/utils/enums.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model/expense_model.dart';

class SummaryController extends GetxController {
  SortType? type;

  List<ExpenseModel> expenseList = <ExpenseModel>[];

  /// Getting Added Expense List from DB
  getListFromDb() async {
    var box = await Hive.openBox("expenseBox");
    String tableName = "expenseList";
    var result = box.get(tableName);
    final jsonData = jsonDecode(result);
    expenseList = (jsonData as List).map((e) {
      return ExpenseModel.fromJson(e);
    }).toList();
  }

  double totalMonthlyExpense() {
    if (expenseList.isEmpty) return 0.0;

    final currentMonth = DateTime.now().month;
    return expenseList
        .where((expense) => expense.date.month == currentMonth)
        .fold(
          0.0,
          (sum, expense) => sum + expense.amount,
        );
  }

  double totalWeeklyExpense() {
    if (expenseList.isEmpty) return 0.0;

    final today = DateTime.now();
    final firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

    return expenseList
        .where((expense) =>
            expense.date.isAfter(firstDayOfWeek) &&
            expense.date.isBefore(lastDayOfWeek.add(const Duration(days: 1))))
        .fold(
          0.0,
          (sum, expense) => sum + expense.amount,
        );
  }
}
