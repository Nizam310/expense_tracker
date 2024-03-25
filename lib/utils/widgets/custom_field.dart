import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final int? maxLine;
  final TextInputType keyboardType;
  final bool? enable;
  final Function(String)? onChanged;
  final Function()? onTap;
  final InputDecoration? decoration;
  final FocusNode focusNode;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;
  const CustomField(
      {super.key,
      required this.controller,
      this.onChanged,
      this.decoration,
      this.label,
      this.hint,
      this.maxLine,
      this.onTap,
      required this.keyboardType,
      this.enable = true,
      required this.focusNode,
      this.onEditingComplete,
      this.validator});

  @override
  Widget build(BuildContext context) {
    InputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.surface, width: 1));

    return TextFormField(
      validator: validator,
      enabled: enable,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      onTap: onTap,
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: (val) {
        FocusScope.of(context).nextFocus();
      },
      onTapOutside: (val) {
        FocusScope.of(context).unfocus();
      },
      onEditingComplete: onEditingComplete,
      cursorColor: Theme.of(context).colorScheme.surface,
      maxLines: maxLine ?? 1,
      style: context.textTheme.bodyMedium?.copyWith(
          fontSize: 15,
          color: Theme.of(context).colorScheme.surface,
          fontWeight: FontWeight.w400),
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            labelStyle: context.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w400),
            hintText: hint,
            errorStyle: context.textTheme.bodyMedium,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            disabledBorder: border,
          ),
    );
  }
}
