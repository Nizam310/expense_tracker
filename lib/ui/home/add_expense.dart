import 'package:expense_tracker/controller/add_expense_controller.dart';
import 'package:expense_tracker/utils/widgets/custom_button.dart';
import 'package:expense_tracker/utils/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/widgets/date_picker.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final controller = Get.put(AddExpenseController());

  @override
  void initState() {
    super.initState();
    controller.initializeService();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Lottie.asset(
                "assets/animations/expense.json",
              )).paddingOnly(bottom: 20),
          CustomField(
            keyboardType: TextInputType.number,
            controller: controller.amountController,
            label: "Amount",
          ).paddingOnly(bottom: 20),
          CustomField(
            keyboardType: TextInputType.datetime,
            controller: controller.dateController,
            label: "Date",
            onTap: () {
              selectDate(
                  selectedDate: controller.selectedDate,
                  controller: controller.dateController);
            },
          ).paddingOnly(bottom: 20),
          CustomField(
            keyboardType: TextInputType.multiline,
            controller: controller.descriptionController,
            label: "Description",
            maxLine: 4,
          ).paddingOnly(bottom: 20),
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                      text: "Add Expense",
                      onTap: () {
                        controller.addExpense();
                      })),
            ],
          )
        ],
      ),
    );
  }
}
