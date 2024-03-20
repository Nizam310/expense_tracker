import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final int? maxLine;
  final TextInputType keyboardType;

  final Function(String)? onChanged;
  final Function()? onTap;
  final InputDecoration? decoration;
  const CustomField(
      {super.key,
      required this.controller,
      this.onChanged,
      this.decoration,
      this.label,
      this.hint,
      this.maxLine,
      this.onTap, required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    InputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black, width: 1));

    return TextFormField(
      keyboardType: keyboardType,
      onTap: onTap,
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: (val){
        FocusScope.of(context).nextFocus();
      },
      maxLines: maxLine ?? 1,
      style: context.textTheme.bodyMedium?.copyWith(
          fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            labelStyle: context.textTheme.bodyMedium?.copyWith(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
            hintText: hint,

            border: border,
            enabledBorder: border,
            focusedBorder: border,
          ),
    );
  }
}
