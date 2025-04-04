import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/Screens/medicines/model/medicine_model.dart';
import 'package:pharmacy_system/Screens/purchases/widget/purchase_item.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';

class PurchasePart extends StatefulWidget {
  PurchasePart({super.key});

  @override
  State<PurchasePart> createState() => _PurchasePartState();
}

class _PurchasePartState extends State<PurchasePart> {
  String getCurrentDate() {
    return DateFormat.yMMMMd().format(DateTime.now()); // e.g., July 7, 2024
  }

  String getCurrentTime() {
    return DateFormat.jm().format(DateTime.now()); // e.g., 10:30 PM
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date: ${getCurrentDate()}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Time: ${getCurrentTime()}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              PurchaseItem(
                dateOfDay: getCurrentDate(),
                timeOfDay: getCurrentTime(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
