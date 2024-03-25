import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final FocusNode focusNode;
  const CustomButton({super.key, required this.text, required this.onTap, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusNode: focusNode,
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(
          text,
          style: context.textTheme.bodyMedium?.copyWith(color: Colors.white),
        )),
      ),
    );
  }
}
