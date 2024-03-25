import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:expense_tracker/controller/home_controller.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../utils/widgets/show_toast.dart';

class AddExpenseController extends GetxController {
  final dateFocusNode = FocusNode();
  final addButtonFocusNode = FocusNode();
  final amountFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final homeController = Get.find<HomeController>();
  final amountController = TextEditingController();

  final dateController = TextEditingController();

  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  RxList<ExpenseModel> expenseList = <ExpenseModel>[].obs;

  addExpense() async {
    if (formKey.currentState!.validate()) {
      var box = await Hive.openBox("expenseBox");

      /// Retrieve existing list from the database
      var savedList = box.get("expenseList");

      List<ExpenseModel> expenseList = [];
      if (savedList != null) {
        expenseList = List<ExpenseModel>.from(
            jsonDecode(savedList).map((model) => ExpenseModel.fromJson(model)));
      }

      expenseList.add(ExpenseModel(
          amount: double.parse(amountController.text),
          date: DateFormat('dd/MM/yyy').parse(dateController.text),
          description: descriptionController.text));

      /// Saving the updated list to the database
      await box.put("expenseList",
          jsonEncode(expenseList.map((e) => e.toJson()).toList()));
      addButtonFocusNode.unfocus();

      /// Resetting the text fields
      amountController.clear();
      dateController.clear();
      descriptionController.clear();

      /// this will show the fields in home
      await homeController.getListFromDb();
      homeController.update();

      Navigator.pop(Get.context!);
      showToast("Expense added successfully");
      update();
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final service = FlutterBackgroundService();

  Future<void> initializeService() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground',
      'MY FOREGROUND SERVICE',
      description: 'This channel is used for important notifications.',
      importance: Importance.low,
    );

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStarted,
        autoStart: true,
        isForegroundMode: true,
        autoStartOnBoot: true,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'Expense Reminder',
        initialNotificationContent: 'Time to add expense',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(),
    );

    service.startService();
  }

  @pragma('vm:entry-point')
  static void onStarted(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      Timer.periodic(const Duration(minutes: 2), (timer) async {
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        AndroidNotificationDetails androidPlatformChannelSpecifics =
            const AndroidNotificationDetails(
          'my_foreground',
          'MY FOREGROUND SERVICE',
          icon: 'ic_bg_service_small',
          importance: Importance.low,
        );
        NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
        );
        await flutterLocalNotificationsPlugin.show(
          889,
          'Expense Reminder',
          'Time to add Expense',
          platformChannelSpecifics,
        );
      });
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  @override
  void onInit() {
    super.onInit();
    initializeService();
    Hive.registerAdapter(ExpenseModelAdapter());
  }
}
