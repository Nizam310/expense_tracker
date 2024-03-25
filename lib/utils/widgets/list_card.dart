import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCard extends StatelessWidget {
  final String date;
  final String amount;
  final String description;
  final int? selectedIndex;
  final int? index;
  final Function() onTap;
  final Function() onEdit;
  final Function() onDelete;
  const ListCard(
      {super.key,
      required this.date,
      required this.amount,
      required this.description,
      this.selectedIndex = -1,
      this.index = 0,
      required this.onTap,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        color: Theme.of(context).colorScheme.onBackground,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: selectedIndex == index
                    ? Theme.of(context).colorScheme.surface
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$$amount",
                  style: context.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  date,
                  style: context.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ).paddingOnly(bottom: 10),
            Text(
              "Description",
              style: context.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              description,
              style: context.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w400),
            ),
            Visibility(
              visible: selectedIndex == index,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _Button(onTap: onEdit, icon: Icons.edit)
                      .paddingOnly(right: 5),
                  _Button(onTap: onDelete, icon: Icons.delete),
                ],
              ).paddingOnly(top: 10),
            )
          ],
        ).paddingSymmetric(vertical: 10, horizontal: 10),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  const _Button({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              shape: BoxShape.circle),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 15,
          )),
    );
  }
}
