import 'dart:async';
import 'dart:convert';
import 'dart:ui';

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
  final amountController = TextEditingController();

  final dateController = TextEditingController();

  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  List<ExpenseModel> expenseList = [];

  addExpense() async {
    /// Checking the given fields are empty or not
    if (amountController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      expenseList.add(ExpenseModel(
          amount: double.parse(amountController.text),
          date: DateFormat('dd-MM-yyy').parse(dateController.text),
          description: descriptionController.text));

      /// Opening Database
      var box = await Hive.openBox("expenseBox");

      /// Remove Duplicates from list
      final reList = expenseList.toSet().toList();

      /// adding the list to db
      await box.put(
          "expenseList", jsonEncode(reList.map((e) => e.toJson()).toList()));

      /// Resetting the text fields

      formKey.currentState?.reset();

      showToast("Expense added successfully");
      update();
    } else {
      /// if the fields are empty then it will show this toast

      showToast("Field must be not empty!");
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
    Hive.registerAdapter(ExpenseModelAdapter());
  }
}
