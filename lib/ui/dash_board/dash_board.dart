import 'package:expense_tracker/controller/dash_board_controller.dart';
import 'package:expense_tracker/ui/home/add_expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DashBoard extends StatelessWidget {
  const DashBoard({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Obx(() => controller.widgetList
                .elementAt(controller.selectedIndex.value)),
          ))
        ],
      ).paddingSymmetric(horizontal: 20, vertical: 20),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).colorScheme.onBackground,
          shape: const CircularNotchedRectangle(),
          notchMargin: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => IconButton(
                  onPressed: () {
                    controller.selectedIndex.value = 0;
                  },
                  icon: const Icon(CupertinoIcons.home),
                  color: controller.selectedIndex.value == 0
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.6),
                ),
              ),
              Obx(
                () => IconButton(
                  onPressed: () {
                    controller.selectedIndex.value = 1;
                  },
                  icon: const Icon(CupertinoIcons.list_bullet_indent),
                  color: controller.selectedIndex.value == 1
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.6),
                ),
              ),
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              context: context,
              builder: (builder) {
                return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: const AddExpense());
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
