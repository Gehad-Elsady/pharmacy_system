import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/Screens/customers/model/customer_model.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';
import 'package:pharmacy_system/backend/models/cart_model.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

String query = "";

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _CustomerViewState extends State<CustomerView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  query = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: "Search for Customers...",
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Customers').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Customers found."));
                  }

                  final results = snapshot.data!.docs.where((doc) {
                    final name = doc['name']?.toString().toLowerCase() ?? '';
                    final phone = doc['phoneNumber']?.toString().toLowerCase() ?? '';
                    return name.contains(query) || phone.contains(query);
                  }).toList();

                  if (results.isEmpty) {
                    return const Center(child: Text("No matching Customers found."));
                  }

                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final model = results[index];
                      final customer = CustomerModel.fromMap(model.data() as Map<String, dynamic>);

                      return GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              final dateFormat = DateFormat('yyyy-MM-dd – hh:mm a');

                              return StreamBuilder<List<CartModel>>(
                                stream: FirebaseFunctions.getUserCartsHistory(customer.phoneNumber),
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

                                  final carts = snapshot.data!..sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
                                                  ...cart.items.map((item) => Text("- ${item.medicineName}")),
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
                            },
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Customer Information",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(thickness: 2, color: Colors.black),
                                buildInfoRow("Customer Name", customer.name),
                                buildInfoRow("Customer Address", customer.address),
                                buildInfoRow("Customer Phone Number", customer.phoneNumber),
                                buildInfoRow("Customer Age", customer.age),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  RichText buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label : ',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
