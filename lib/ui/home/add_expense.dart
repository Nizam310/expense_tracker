import 'package:expense_tracker/controller/add_expense_controller.dart';
import 'package:expense_tracker/utils/extentions.dart';
import 'package:expense_tracker/utils/widgets/custom_button.dart';
import 'package:expense_tracker/utils/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/widgets/date_picker.dart';

class AddExpense extends StatelessWidget {
  const AddExpense({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddExpenseController());
    return Form(
      key: controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomField(
            focusNode: controller.amountFocusNode,
            onEditingComplete: () {
              controller.amountFocusNode.requestFocus(controller.dateFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the amount.';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            controller: controller.amountController,
            label: "Amount",
          ).paddingOnly(bottom: 20),
          CustomField(
            focusNode: controller.dateFocusNode,
            onEditingComplete: () {
              controller.dateFocusNode
                  .requestFocus(controller.descriptionFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the date.';
              } else if (!value.isValidDateFormat()) {
                return 'Invalid date format! Use dd/MM/yyyy.';
              }
              return null;
            },
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
            focusNode: controller.descriptionFocusNode,
            onEditingComplete: () {
              controller.descriptionFocusNode
                  .requestFocus(controller.addButtonFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a description.';
              } else if (!value.isValidDescription()) {
                return 'Description must have more than 5 characters.';
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
            controller: controller.descriptionController,
            label: "Description",
            maxLine: 4,
          ).paddingOnly(bottom: 20),
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                      focusNode: controller.addButtonFocusNode,
                      text: "Add Expense",
                      onTap: () {
                        controller.addExpense();
                      })),
            ],
          )
        ],
      ).paddingSymmetric(vertical: 20, horizontal: 20),
    );
  }
}
