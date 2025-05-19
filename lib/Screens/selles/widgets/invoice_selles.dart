import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/customers/model/customer_model.dart';
import 'package:pharmacy_system/Screens/customers/widgets/add_customer_form.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';
import 'package:pharmacy_system/backend/providers/sales_provider.dart';
import 'package:provider/provider.dart';

class InvoiceSelles extends StatefulWidget {
  const InvoiceSelles({super.key});

  @override
  State<InvoiceSelles> createState() => _InvoiceSellesState();
}

class _InvoiceSellesState extends State<InvoiceSelles> {
    final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Consumer<SalesProvider>(
                builder: (context, cart, child) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Customer Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: SingleChildScrollView(
                              child: DataTable(
                                columnSpacing: 20,
                                horizontalMargin: 10,
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.green.withOpacity(0.2),
                                ),
                                columns: const [
                                  DataColumn(label: Text('اسم الصنف')),
                                  DataColumn(label: Text('تاريخ الصلاحية')),
                                  DataColumn(label: Text('الوحدة')),
                                  DataColumn(label: Text('الكمية')),
                                  DataColumn(label: Text('سعر البيع')),
                                  DataColumn(label: Text('الرصيد')),
                                  DataColumn(label: Text('حذف')),
                                ],
                                rows: cart.items.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.medicineName)),
                                      DataCell(
                                        DropdownButton<String>(
                                          value: item.expiryDate,
                                          items: item.sortedExpiryDates
                                              .map((date) => DropdownMenuItem(
                                                    value: date,
                                                    child: Text(date),
                                                  ))
                                              .toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                item.expiryDate = newValue;
                                                // Validate quantity after changing expiry date
                                                if (!item.isQuantityValid) {
                                                  item.quantity =
                                                      item.maxAllowedQuantity;
                                                }
                                                cart.updateItem(item);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        DropdownButton<String>(
                                          value: item.selectedUnit,
                                          items: const [
                                            DropdownMenuItem(
                                                value: 'strip',
                                                child: Text('علبة')),
                                            DropdownMenuItem(
                                                value: 'unit',
                                                child: Text('شريط')),
                                          ],
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                item.selectedUnit = newValue;
                                                // Validate quantity after changing unit
                                                if (!item.isQuantityValid) {
                                                  item.quantity =
                                                      item.maxAllowedQuantity;
                                                }
                                                cart.updateItem(item);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        TextField(
                                          controller: TextEditingController(
                                              text: item.quantity.toString()),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            errorText: !item.isQuantityValid
                                                ? 'Max: ${item.maxAllowedQuantity}'
                                                : null,
                                          ),
                                          style: const TextStyle(fontSize: 14),
                                          onChanged: (value) {
                                            final newQuantity =
                                                int.tryParse(value) ?? 0;
                                            if (newQuantity >= 0) {
                                              setState(() {
                                                item.quantity = newQuantity;
                                                cart.updateItem(item);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${item.price} / علبة'),
                                            Text(
                                              '${(item.price / item.smallUnitNumber).toStringAsFixed(2)} / شريط',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                          Text(item.currentStock.toString())),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            cart.removeItem(item.medicineId);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: \$${cart.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                              ),
                              onPressed: () async {
                                if (cart.items.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No items in cart'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                if (_phoneController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter customer phone number'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  // Try getting the customer model
                                  CustomerModel? customerModel =
                                      await FirebaseFunctions
                                              .getCustomerToCheckOut(
                                                  _phoneController.text)
                                          .first;

                                  if (customerModel != null) {
                                    await FirebaseFunctions.saveCart(
                                      cart.items,
                                      cart.total,
                                      _phoneController.text,
                                    );

                                    await FirebaseFunctions
                                        .updateMedicinesInInventory(cart.items);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Sale completed successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    cart.clear();
                                  } else {
                                    // Customer not found
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title:
                                            const Text('Customer not found!'),
                                        content: const Text(
                                            'Please add a customer to complete the sale!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  backgroundColor:
                                                      Colors.blueGrey,
                                                  title: const Text(
                                                    "Add New Customer",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: SizedBox(
                                                    width: 600,
                                                    child: AddCustomerForm(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text('Add Customer'),
                                          ),
                                        ],
                                      ),
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please add a customer to complete the sale!'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Error saving sale: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Complete Sale'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
  }
    @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}