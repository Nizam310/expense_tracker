import 'package:expense_tracker/controller/dash_board_cotroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final controller = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: Drawer(
        child: Builder(builder: (context) {
          return Column(
            children: [
              ListTile(
                title: const Text("Add Expense"),
                onTap: () {
                  setState(() {
                    controller.selectedIndex.value = 0;
                    Scaffold.of(context).closeDrawer();
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black)),
              ).paddingOnly(bottom: 10),
              ListTile(
                title: const Text("View Expense List"),
                onTap: () {
                  setState(() {
                    controller.selectedIndex.value = 1;
                    Scaffold.of(context).closeDrawer();
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black)),
              ).paddingOnly(bottom: 10),
              ListTile(
                title: const Text("View Summary List"),
                onTap: () {
                  setState(() {
                    controller.selectedIndex.value = 2;
                    Scaffold.of(context).closeDrawer();
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black)),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 20);
        }),
      ),
      appBar: AppBar(
        title: Text(controller.selectedIndex.value == 0
            ? "Add Expense"
            : controller.selectedIndex.value == 1
                ? "View Expense List"
                : controller.selectedIndex.value == 2
                    ? "View Summary List"
                    : "Expense"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child:
                controller.widgetList.elementAt(controller.selectedIndex.value),
          ))
        ],
      ).paddingSymmetric(horizontal: 20, vertical: 20),
    );
  }
}
