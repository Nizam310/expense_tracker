import 'package:expense_tracker/controller/view_summary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/enums.dart';

class ViewSummary extends StatefulWidget {
  const ViewSummary({super.key});

  @override
  State<ViewSummary> createState() => _ViewSummaryState();
}

class _ViewSummaryState extends State<ViewSummary> {
  InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black, width: 1));
  final controller = Get.put(SummaryController());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sort List",
          style: context.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ).paddingOnly(left: 6, bottom: 10),
        DropdownButtonFormField<SortType>(
          items: SortType.values
              .map((e) =>
                  DropdownMenuItem<SortType>(value: e, child: Text(e.name)))
              .toList(),
          onChanged: (val) {
            setState(() {
              controller.type = val!;
              controller.getListFromDb();
            });
          },
          decoration: InputDecoration(
              border: border,
              enabledBorder: border,
              focusedBorder: border,
              hintText: "Select to sort the list"),
        ).paddingOnly(bottom: 20),
        Visibility(
          visible: controller.type!=null,
          child: Row(
            children: [
              Expanded(
                child: Card(elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(controller.type == SortType.monthly
                          ? "Total Monthly Expense"
                          : "Total Weekly Expense",style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
                      Text(
                        controller.type == SortType.monthly
                            ? controller.totalMonthlyExpense().toString()
                            : controller.totalWeeklyExpense().toString(),
                        style: context.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                      ).paddingOnly(top: 10),
                    ],
                  ).paddingAll(20),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
