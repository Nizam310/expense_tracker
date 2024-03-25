import 'package:expense_tracker/ui/home/add_expense.dart';
import 'package:expense_tracker/ui/home/home.dart';
import 'package:expense_tracker/ui/home/view_expense_list.dart';
import 'package:get/get.dart';


class DashboardController extends GetxController{

  RxInt selectedIndex = 0.obs;
  RxList widgetList = [
    const Home(),
    const ViewExpenseList(),
    const AddExpense(),
    // const ViewSummary(),
  ].obs;

}