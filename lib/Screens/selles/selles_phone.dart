import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';
import 'package:pharmacy_system/backend/models/cart_model.dart';

class SellesPhone extends StatefulWidget {
  const SellesPhone({super.key, required this.phoneNumber});
  final String phoneNumber;

  @override
  State<SellesPhone> createState() => _SellesPhoneState();
}

class _SellesPhoneState extends State<SellesPhone> {
  final dateFormat = DateFormat('yyyy-MM-dd – hh:mm a');
  @override
  Widget build(BuildContext context) {
    return  

       StreamBuilder<List<CartModel>>(
        stream: FirebaseFunctions.getUserCartsHistory(widget.phoneNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(
              title: Center(child: Text("Customer Invoices History")),
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return AlertDialog(
              title: const Text("Customer Invoices History"),
              content: const Text("No invoice history found."),
              actions: [
                TextButton(
                  onPressed: () {
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          }

          final carts = snapshot.data!;

          return AlertDialog(
            title: const Text("Customer Invoices History"),
            content: SizedBox(
              height: 400,
              width: 350,
              child: ListView.builder(
                itemCount: carts.length,
                itemBuilder: (context, index) {
                  final cart = carts[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Invoice ID: ${cart.id}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("Phone: ${cart.customerPhoneNumber}"),
                          Text("Date: ${dateFormat.format(cart.createdAt)}"),
                          Text(
                            "Total: \$${cart.total.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.green),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Items:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          ...cart.items
                              .map((item) => Text("- ${item.medicineName}"))
                              .toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
  }
}