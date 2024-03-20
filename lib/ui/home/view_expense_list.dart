import 'package:expense_tracker/controller/view_expense_controller.dart';
import 'package:expense_tracker/utils/widgets/custom_button.dart';
import 'package:expense_tracker/utils/widgets/date_picker.dart';
import 'package:expense_tracker/utils/widgets/list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/widgets/custom_field.dart';

class ViewExpenseList extends StatefulWidget {
  const ViewExpenseList({super.key});

  @override
  State<ViewExpenseList> createState() => _ViewExpenseListState();
}

class _ViewExpenseListState extends State<ViewExpenseList> {
  final controller = Get.put(ViewExpenseController());

  @override
  void initState() {
    super.initState();
    controller.type = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomField(
                keyboardType: TextInputType.datetime,
                controller: controller.dateFromController,
                label: "Date From",
                onTap: () {
                  selectDate(
                      selectedDate: controller.selectedDate,
                      controller: controller.dateFromController);
                },
              ).paddingOnly(right: 5),
            ),
            Expanded(
              child: CustomField(
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
        CustomButton(
          text: "Search",
          onTap: () {
            setState(() {
              controller.searchList();
            });
          },
        ).paddingSymmetric(vertical: 20),
        Visibility(
          visible: controller.filteredExpenses().isNotEmpty,
          child: GetBuilder(
              init: ViewExpenseController(),
              builder: (controller) {
                return Row(
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
                              key: ValueKey(index),
                              children: [
                                Expanded(
                                  child: Animate(
                                    delay: Duration(
                                        milliseconds: 300 + (index * 100)),
                                    effects: const [
                                      ScaleEffect(),
                                    ],
                                    child: ListCard(
                                      date: DateFormat('dd-MM-yyy')
                                          .format(i.date),
                                      amount: i.amount.toString(),
                                      description: i.description,
                                      selectedIndex: controller.selectedIndex,
                                      index: index,
                                      onTap: () {
                                        setState(() {
                                          if (controller.selectedIndex ==
                                              index) {
                                            controller.selectedIndex = -1;
                                          } else {
                                            controller.selectedIndex = index;
                                          }
                                        });
                                      },
                                      onEdit: () {
                                        setState(() {
                                          controller.onEdit(
                                              index, controller.expenseList);
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
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller: controller
                                                              .amountController,
                                                          label: "Amount",
                                                        ).paddingOnly(
                                                            bottom: 20),
                                                        CustomField(
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
                                                                        .dateFromController);
                                                          },
                                                        ).paddingOnly(
                                                            bottom: 20),
                                                        CustomField(
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
                                                                        text:
                                                                            "Update Expense",
                                                                        onTap:
                                                                            () {
                                                                          controller.updateExpense(
                                                                              list: controller.expenseList,
                                                                              index: index);
                                                                          controller
                                                                              .update();
                                                                        })),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        });
                                      },
                                      onDelete: () {
                                        setState(() {
                                          controller.expenseList
                                              .removeAt(index);
                                          controller.selectedIndex = -1;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList()),
                    ),
                  ],
                );
              }),
        ),
        Visibility(
            visible: controller.filteredExpenses().isEmpty &&
                controller.dateToController.text.isNotEmpty &&
                controller.dateFromController.text.isNotEmpty,
            child: Center(
                child: Text(
              "No items found.",
              style: context.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            )))
      ],
    );
  }
}
