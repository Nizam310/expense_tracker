import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCard extends StatelessWidget {
  final String date;
  final String amount;
  final String description;
  final int selectedIndex;
  final int index;
  final Function() onTap;
  final Function() onEdit;
  final Function() onDelete;
  const ListCard(
      {super.key,
      required this.date,
      required this.amount,
      required this.description,
      required this.selectedIndex,
      required this.index,
      required this.onTap,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color:
                    selectedIndex == index ? Colors.black : Colors.transparent),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date",
                      style: context.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      date,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount",
                      style: context.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      amount,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ).paddingOnly(bottom: 10),
            Text(
              "Description ",
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
                  button(onTap: onEdit, icon: Icons.edit).paddingOnly(right: 5),
                  button(onTap: onDelete, icon: Icons.delete),
                ],
              ),
            )
          ],
        ).paddingSymmetric(vertical: 10, horizontal: 10),
      ),
    );
  }

  Widget button({required Function() onTap, required IconData icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black), shape: BoxShape.circle),
          child: Icon(
            icon,
            size: 15,
          )),
    );
  }
}
