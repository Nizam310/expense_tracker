
import 'package:expense_tracker/ui/dash_board/dash_board.dart';
import 'package:expense_tracker/ui/home/add_expense.dart';
import 'package:expense_tracker/ui/home/view_expense_list.dart';
import 'package:expense_tracker/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal Expense Tracker',
        theme: ThemeData(
            colorScheme: AppColor.lightColorScheme,
            textTheme: TextTheme(
              bodyMedium: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
              bodyLarge: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
              bodySmall: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
              headlineLarge: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
              headlineSmall: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w600),
              headlineMedium: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w600),
              titleMedium: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w600),
              titleSmall: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w600),
              titleLarge: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w600),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)))),
        getPages: [
          GetPage(name: "/", page: () => const DashBoard()),
          GetPage(name: "/addExpense", page: () => const AddExpense()),
          GetPage(name: "/viewExpense", page: () => const ViewExpenseList()),
        ],
      ),
    );
  }
}
