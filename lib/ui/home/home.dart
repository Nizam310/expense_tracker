import 'package:expense_tracker/controller/dash_board_controller.dart';
import 'package:expense_tracker/controller/home_controller.dart';
import 'package:expense_tracker/utils/widgets/list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text.rich(
                  TextSpan(
                      text: "Hi, ",
                      style: context.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: "Amigo",
                          style: context.textTheme.headlineLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )
                      ]),
                )
              ],
            ),
            Animate(
              effects: const [FlipEffect()],
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/user.jpg"),
              ),
            ),
          ],
        ).paddingOnly(bottom: 20),
        Text(
          "Expense Overview",
          style: context.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ).paddingOnly(bottom: 20),
        Animate(
          effects: const [ScaleEffect()],
          child: Row(children: [
            Expanded(
              child: Container(
                height: 120,
                padding: const EdgeInsets.all(10),
                decoration: (BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Expense Total",
                          style: context.textTheme.bodySmall?.copyWith(),
                        ).paddingOnly(bottom: 10),
                        Obx(
                          () => Text(
                            "\$${homeController.totalExpense().obs.toString()}",
                            style: context.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      "assets/images/expense.webp",
                      height: 100,
                    )
                  ],
                ),
              ).paddingOnly(right: 10),
            ),
          ]).paddingOnly(bottom: 20),
        ),
        Animate(
          effects: const [FlipEffect()],
          child: Row(
            children: [
              Expanded(
                  child: Obx(
                () => _ExpenseCard(
                  title: "Month",
                  value:
                      "\$${homeController.totalMonthlyExpense().obs.toString()}",
                ).paddingOnly(right: 10),
              )),
              Expanded(
                  child: Obx(
                () => _ExpenseCard(
                  title: "Week",
                  value:
                      "\$${homeController.totalWeeklyExpense().obs.toString()}",
                ),
              )),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Expense List",
              style: context.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            GetBuilder<DashboardController>(builder: (dashController) {
              return TextButton(
                onPressed: () {
                  dashController.selectedIndex.value = 1;
                },
                child: Text(
                  "Sort",
                  style: context.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              );
            })
          ],
        ).paddingSymmetric(vertical: 20),
     Obx(
       ()=> Visibility(
         visible: homeController.expenseList.obs.value.isNotEmpty,
         child: Column(
                          children: homeController.expenseList.obs.value
                              .map((e) => Animate(
                                    effects: const [
                                      ScaleEffect(),
                                    ],
                                    child: ListCard(
                                      date: DateFormat('dd/MM/yyy')
                                          .format(e.date.obs.value),
                                      amount: e.amount.toString(),
                                      description: e.description.toString(),
                                      onTap: () {},
                                      onEdit: () {},
                                      onDelete: () {},
                                    ).paddingOnly(bottom: 10),
                                  ))
                              .toList().obs),
       ),
     ),
    Obx(() => Visibility(
      visible: homeController.expenseList.obs.value.isEmpty,
      child: Center(
          child: Text(
            "No data found!",
            style: context.textTheme.bodyLarge,
          )),
    ))

      ],
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final String title;
  final String value;

  const _ExpenseCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(10),
      decoration: (BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.textTheme.bodySmall?.copyWith(),
          ).paddingOnly(bottom: 10),
          Text(
            value,
            style: context.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
