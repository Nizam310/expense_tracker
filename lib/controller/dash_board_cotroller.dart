import 'package:expense_tracker/ui/home/add_expense.dart';
import 'package:expense_tracker/ui/home/view_expense_list.dart';
import 'package:get/get.dart';

import '../ui/home/view_summary.dart';

class DashboardController extends GetxController{

  RxInt selectedIndex = 0.obs;
  RxList widgetList = [
    const AddExpense(),
    const ViewExpenseList(),
    const ViewSummary(),
  ].obs;

}