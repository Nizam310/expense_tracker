import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showToast(String message) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ));
}
