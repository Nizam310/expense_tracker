import 'package:expense_tracker/controller/view_expense_controller.dart';
import 'package:expense_tracker/utils/extentions.dart';
import 'package:expense_tracker/utils/widgets/custom_button.dart';
import 'package:expense_tracker/utils/widgets/date_picker.dart';
import 'package:expense_tracker/utils/widgets/list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/widgets/custom_field.dart';

class ViewExpenseList extends StatelessWidget {
  const ViewExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ViewExpenseController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text("Expense List", style: context.textTheme.headlineSmall)
                .paddingOnly(bottom: 20)),
        Text("Sort by date",
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600))
            .paddingOnly(bottom: 20),
        GetBuilder<ViewExpenseController>(builder: (controller) {
          return Form(
            key: controller.formKey2,
            child: Row(
              children: [
                Expanded(
                  child: CustomField(
                    onEditingComplete: () {
                      controller.dateFromFocusNode
                          .requestFocus(controller.dateToFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the date.';
                      } else if (!value.isValidDateFormat()) {
                        return 'Invalid date format! Use dd/MM/yyyy.';
                      }
                      return null;
                    },
                    focusNode: controller.dateFromFocusNode,
                    keyboardType: TextInputType.datetime,
                    controller: controller.dateFromController,
                    label: "Date From",
                    onTap: () {
                      selectDate(
                          selectedDate: controller.selectedDate,
                          controller: controller.dateFromController);
                    },
                  ).paddingOnly(right: 10),
                ),
                Expanded(
                  child: CustomField(
                    onEditingComplete: () {
                      controller.dateToFocusNode
                          .requestFocus(controller.searchButtonFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the date.';
                      } else if (!value.isValidDateFormat()) {
                        return 'Invalid date format! Use dd/MM/yyyy.';
                      }
                      return null;
                    },
                    focusNode: controller.dateToFocusNode,
                    keyboardType: TextInputType.datetime,
                    controller: controller.dateToController,
                    label: "Date To",
                    onTap: () {
                      selectDate(
                          selectedDate: controller.selectedDate,
                          controller: controller.dateToController);
                    },
                  ),
                ),
              ],
            ),
          );
        }),
        GetBuilder<ViewExpenseController>(
            init: ViewExpenseController(),
            builder: (controller) {
              return CustomButton(
                focusNode: controller.searchButtonFocusNode,
                text: "Search",
                onTap: () {
                  controller.searchList();
                },
              ).paddingSymmetric(vertical: 20);
            }),
        GetBuilder(
            init: ViewExpenseController(),
            builder: (controller) {
              return Visibility(
                visible: controller.filteredExpenses().isNotEmpty,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: controller
                              .filteredExpenses()
                              .asMap()
                              .entries
                              .map((e) {
                            var i = e.value;
                            var index = e.key;
                            return Row(
                              children: [
                                Expanded(
                                  child: Animate(
                                    delay: Duration(
                                        milliseconds: 300 + (index * 100)),
                                    effects: const [
                                      ScaleEffect(),
                                    ],
                                    child: Obx(
                                      () => ListCard(
                                        date: DateFormat('dd/MM/yyy')
                                            .format(i.date.obs.value),
                                        amount: i.amount.toString().obs.value,
                                        description: i.description.obs.value,
                                        selectedIndex:
                                            controller.selectedIndex.obs.value,
                                        index: index,
                                        onTap: () {
                                          if (controller.selectedIndex ==
                                              index) {
                                            controller.selectedIndex = -1;
                                            controller.update();
                                          } else {
                                            controller.selectedIndex = index;
                                            controller.update();
                                          }
                                        },
                                        onEdit: () {
                                          controller.onEdit(index,
                                              controller.filteredExpenses());
                                          showDialog(
                                              context: Get.context!,
                                              builder: (builder) {
                                                return AlertDialog(
                                                  scrollable: true,
                                                  content: Form(
                                                    key: controller.formKey,
                                                    child: Column(
                                                      children: [
                                                        CustomField(
                                                          onEditingComplete:
                                                              () {
                                                            controller
                                                                .amountFocusNode
                                                                .requestFocus(
                                                                    controller
                                                                        .dateFocusNode);
                                                          },
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Please enter the amount.';
                                                            }
                                                            return null;
                                                          },
                                                          focusNode: controller
                                                              .amountFocusNode,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller: controller
                                                              .amountController,
                                                          label: "Amount",
                                                        ).paddingOnly(
                                                            bottom: 20),
                                                        CustomField(
                                                          onEditingComplete:
                                                              () {
                                                            controller
                                                                .dateFocusNode
                                                                .requestFocus(
                                                                    controller
                                                                        .descriptionFocusNode);
                                                          },
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Please enter the date.';
                                                            } else if (!value
                                                                .isValidDateFormat()) {
                                                              return 'Invalid date format! Use dd/MM/yyyy.';
                                                            }
                                                            return null;
                                                          },
                                                          focusNode: controller
                                                              .dateFocusNode,
                                                          keyboardType:
                                                              TextInputType
                                                                  .datetime,
                                                          controller: controller
                                                              .dateController,
                                                          label: "Date",
                                                          onTap: () {
                                                            selectDate(
                                                                selectedDate:
                                                                    controller
                                                                        .selectedDate,
                                                                controller:
                                                                    controller
                                                                        .dateController);
                                                          },
                                                        ).paddingOnly(
                                                            bottom: 20),
                                                        CustomField(
                                                          onEditingComplete:
                                                              () {
                                                            controller
                                                                .descriptionFocusNode
                                                                .requestFocus(
                                                                    controller
                                                                        .updateButtonFocusNode);
                                                          },
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Please enter a description.';
                                                            } else if (!value
                                                                .isValidDescription()) {
                                                              return 'Description must have more than 5 characters.';
                                                            }
                                                            return null;
                                                          },
                                                          focusNode: controller
                                                              .descriptionFocusNode,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          controller: controller
                                                              .descriptionController,
                                                          label: "Description",
                                                          maxLine: 4,
                                                        ).paddingOnly(
                                                            bottom: 20),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    CustomButton(
                                                                        focusNode:
                                                                            controller
                                                                                .updateButtonFocusNode,
                                                                        text:
                                                                            "Update Expense",
                                                                        onTap:
                                                                            () async {
                                                                          controller.updateExpense(
                                                                              list: controller.filteredExpenses(),
                                                                              index: index);
                                                                        })),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        onDelete: () {
                                          controller.markExpenseForDeletion(
                                              index,
                                              controller.filteredExpenses());
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList()),
                    ),
                  ],
                ),
              );
            }),
        GetBuilder<ViewExpenseController>(builder: (controller) {
          return Visibility(
              visible: controller.filteredExpenses().isEmpty &&
                  controller.dateToController.text.isNotEmpty &&
                  controller.dateFromController.text.isNotEmpty,
              child: Center(
                  child: Text(
                "No items found.",
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              )));
        })
      ],
    );
  }
}
