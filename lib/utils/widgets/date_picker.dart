import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
/// This is the pop up coming from when we select a date

Future<void> selectDate(
    {required DateTime selectedDate,
      required TextEditingController controller}) async {
  final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  if (picked != null && picked != selectedDate) {
    final formattedDate = DateFormat('dd/MM/yyy').format(picked);
    controller.text = formattedDate;
    FocusScope.of(Get.context!).unfocus();
  }
}
