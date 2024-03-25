import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model/expense_model.dart';

class HomeController extends GetxController {
  RxList<ExpenseModel> expenseList = <ExpenseModel>[].obs;

  /// Getting Added Expense List from DB
  getListFromDb() async {
    var box = await Hive.openBox("expenseBox");
    String tableName = "expenseList";
    var result = box.get(tableName);
    final jsonData = jsonDecode(result);
    expenseList.value = (jsonData as List).map((e) {
      return ExpenseModel.fromJson(e);
    }).toList();
  }

  /// get total monthly expense
  double totalMonthlyExpense() {
    getListFromDb();
    if (expenseList.isEmpty) return 0.0;

    final currentMonth = DateTime.now().month;
    return expenseList
        .where((expense) => expense.date.month == currentMonth)
        .fold(
          0.0,
          (sum, expense) => sum + expense.amount,
        );
  }

  /// get total weekly expense
  double totalWeeklyExpense() {
    getListFromDb();
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

  /// get total all expense
  double totalExpense() {
    getListFromDb();
    return expenseList.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  @override
  void onInit() {
    super.onInit();
    /// Getting previously added db list
    getListFromDb();
  }
}
