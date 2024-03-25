import 'dart:convert';

import 'package:expense_tracker/controller/home_controller.dart';
import 'package:expense_tracker/utils/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../model/expense_model.dart';

class ViewExpenseController extends GetxController {

  final homeController = Get.find<HomeController>();

  final updateButtonFocusNode = FocusNode();
  final searchButtonFocusNode = FocusNode();
  final dateFromFocusNode = FocusNode();
  final dateToFocusNode = FocusNode();
  final dateFocusNode = FocusNode();

  final amountFocusNode = FocusNode();

  final descriptionFocusNode = FocusNode();

  final dropController = TextEditingController();

  final amountController = TextEditingController();

  final dateController = TextEditingController();

  final dateFromController = TextEditingController();

  final dateToController = TextEditingController();

  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  int selectedIndex = -1.obs;

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


  /// Filtered Date List
  List<ExpenseModel> filteredExpenses() {
    getListFromDb();

    /// Checking the given fields are empty or not
    if (dateFromController.text.isNotEmpty &&
        dateToController.text.isNotEmpty) {
      /// converting the string date to DateTime
      DateTime startDate =
      DateFormat('dd/MM/yyyy').parse(dateFromController.text);
      DateTime endDate = DateFormat('dd/MM/yyyy').parse(dateToController.text);

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
    if (formKey2.currentState!.validate()) {
      filteredExpenses().assignAll(filteredExpenses());
      searchButtonFocusNode.unfocus();
      update();
    }
  }

  updateExpense({required int index, required List<ExpenseModel> list}) async {
    if (formKey.currentState!.validate()) {
      ExpenseModel updatedExpense = ExpenseModel(
        amount: double.parse(amountController.text),
        date: DateFormat('dd/MM/yyyy').parse(dateController.text),
        description: descriptionController.text,
      );

      final demoList = updatedExpense;
      list[index] = demoList;
      update();
      int expenseIndexInList = expenseList.indexWhere((expense) =>
      expense.amount == filteredExpenses()[index].amount &&
          expense.date == filteredExpenses()[index].date &&
          expense.description == filteredExpenses()[index].description);

      if (expenseIndexInList != -1) {
        var box = await Hive.openBox("expenseBox");

        /// Retrieve existing list from the database
        var savedList = box.get("expenseList");

        if (savedList != null) {
          expenseList.value = List<ExpenseModel>.from(jsonDecode(savedList)
              .map((model) => ExpenseModel.fromJson(model)));
        }

        expenseList[expenseIndexInList].amount = updatedExpense.amount;

        expenseList[expenseIndexInList].date = updatedExpense.date;

        expenseList[expenseIndexInList].description =
            updatedExpense.description;

        /// Saving the updated list to the database
        await box.put("expenseList",
            jsonEncode(expenseList.map((e) => e.toJson()).toList()));
        FocusScope.of(Get.context!).requestFocus(searchButtonFocusNode);
      }
      formKey.currentState?.reset();
      showToast("Expense updated successfully");
      Navigator.pop(Get.context!);
    }
  }

  updateExpensesInDb(List<ExpenseModel> list) async {
    var box = await Hive.openBox("expenseBox");
    String tableName = "expenseList";
    var resList = list.toSet().toList();
    await box.put(
        tableName, jsonEncode(resList.map((e) => e.toJson()).toList()));
  }

  onEdit(int index, List list) async {
    amountController.text = list[index].amount.toString();
    dateController.text = DateFormat('dd/MM/yyyy').format(list[index].date);
    descriptionController.text = list[index].description;
  }

  markExpenseForDeletion(int index, List list) async {
    await getListFromDb();
    ExpenseModel expenseToDelete = list[index];

    int expenseIndexInList = expenseList.indexWhere((expense) =>
    expense.amount == expenseToDelete.amount &&
        expense.date == expenseToDelete.date &&
        expense.description == expenseToDelete.description);

    if (expenseIndexInList != -1) {
      expenseList.removeAt(expenseIndexInList);
      list.removeAt(index);
      await updateExpensesInDb(expenseList);

      debugPrint('Item removed from both lists');
      update();
    } else {
      debugPrint('Item not found in expenseList');
    }
  }
}