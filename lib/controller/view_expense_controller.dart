import 'dart:convert';

import 'package:expense_tracker/utils/enums.dart';
import 'package:expense_tracker/utils/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../model/expense_model.dart';

class ViewExpenseController extends GetxController {
  final dropController = TextEditingController();

  final amountController = TextEditingController();

  final dateController = TextEditingController();

  final dateFromController = TextEditingController();

  final dateToController = TextEditingController();

  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  SortType? type;

  int selectedIndex = -1.obs;

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

  /// Filtered Date List
  List<ExpenseModel> filteredExpenses() {
    getListFromDb();

    /// Checking the given fields are empty or not
    if (dateFromController.text.isNotEmpty &&
        dateToController.text.isNotEmpty) {
      /// converting the string date to DateTime
      DateTime startDate =
          DateFormat('dd-MM-yyy').parse(dateFromController.text);
      DateTime endDate = DateFormat('dd-MM-yyy').parse(dateToController.text);

      /// Sorting the dates(fromDate to toDate) with where condition
      return expenseList.where((expense) {
        DateTime expenseDate = expense.date;
        return expenseDate
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            expenseDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    } else {
      return [];
    }
  }

  searchList() {
    /// Checking the given fields are empty or not
    if (dateFromController.text.isNotEmpty &&
        dateToController.text.isNotEmpty) {
      filteredExpenses();
      Future.delayed(
          const Duration(seconds: 1), () => dateFromController.clear());
      Future.delayed(
          const Duration(seconds: 1), () => dateToController.clear());
      Future.delayed(
          const Duration(seconds: 1), () => filteredExpenses().clear());
    } else {
      /// if the fields are empty then it will show this toast

      showToast("Field must be not empty!");
    }
  }

  updateExpense({required List list, required int index}) async {
    /// Checking the given fields are empty or not
    if (amountController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      list[index] = ExpenseModel(
          amount: double.parse(amountController.text),
          date: DateFormat('dd-MM-yyy').parse(dateController.text),
          description: descriptionController.text);

      /// Opening Database
      var box = await Hive.openBox("expenseBox");

      String tableName = "expenseList";

      /// Remove Duplicates from list
      final reList = list.toSet().toList();

      /// adding the list to db

      await box.put(
          tableName, jsonEncode(reList.map((e) => e.toJson()).toList()));

      debugPrint(box.get(tableName));

      /// Resetting the text fields
      formKey.currentState?.reset();

      showToast("Expense updated successfully");

      /// exiting from the dialogue
      Navigator.pop(Get.context!);
      update();
    } else {
      /// if the fields are empty then it will show this toast

      showToast("Field must be not empty!");
    }
  }

  onEdit(int index, List list) {
    /// Adding data to the given fields
    amountController.text = list[index].amount.toString();
    dateController.text = DateFormat('dd-MM-yyy').format(list[index].date);
    descriptionController.text = list[index].description;
  }
}
