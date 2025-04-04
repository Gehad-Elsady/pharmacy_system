import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/Screens/medicines/model/medicine_model.dart';
import 'package:pharmacy_system/Screens/purchases/model/purchases_model.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';

class PurchaseItem extends StatefulWidget {
  String dateOfDay;
  String timeOfDay;
  PurchaseItem({super.key, required this.dateOfDay, required this.timeOfDay});

  @override
  State<PurchaseItem> createState() => _PurchaseItemState();
}

class _PurchaseItemState extends State<PurchaseItem> {
  final List<TextEditingController> _priceControllers = [];
  final List<TextEditingController> _quantityControllers = [];
  final List<TextEditingController> _expiryControllers = [];
  final List<TextEditingController> _unitNumberControllers = [];
  final List<String?> _selectedSmallUnits = [];
  final TextEditingController supplierIdController = TextEditingController();

  final TextEditingController invoiceIdController = TextEditingController();

  final List<String> smallUnits = [
    'Box',
    'Bottle',
    'Strip',
    'Tablet',
    'Capsule'
  ];

  // ValueNotifier to track total price
  final ValueNotifier<double> _totalPrice = ValueNotifier<double>(0.0);

  @override
  void dispose() {
    for (var controller in [
      ..._priceControllers,
      ..._quantityControllers,
      ..._expiryControllers,
      ..._unitNumberControllers
    ]) {
      controller.dispose();
    }
    _totalPrice.dispose(); // Dispose ValueNotifier
    super.dispose();
  }

  void _updateTotalPrice() {
    double total = 0.0;
    for (int i = 0; i < _priceControllers.length; i++) {
      double price = double.tryParse(_priceControllers[i].text) ?? 0.0;
      int quantity = int.tryParse(_quantityControllers[i].text) ?? 1;
      total += price * quantity;
    }
    _totalPrice.value = total; // Update ValueNotifier
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: supplierIdController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a Supplier ID";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.numbers,
                      color: Colors.black,
                    ),
                    hintText: "Enter Supplier ID",
                    hintStyle: const TextStyle(color: Colors.black),
                    labelText: "Supplier ID",
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: invoiceIdController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an Invoice ID";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.numbers,
                      color: Colors.black,
                    ),
                    hintText: "Enter Invoice ID",
                    hintStyle: const TextStyle(color: Colors.black),
                    labelText: "Invoice ID",
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<MedicineModel?>>(
              stream: FirebaseFunctions.getPurchasesData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No Medicines found."));
                }

                final List<MedicineModel?> purchaseData = snapshot.data!;
                _initializeControllers(purchaseData.length);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: purchaseData.length,
                        itemBuilder: (context, index) {
                          final medicine = purchaseData[index];
                          if (medicine == null) return const SizedBox.shrink();

                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      medicine.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _buildTextFormField(
                                    controller: _priceControllers[index],
                                    label: "Medicine Price",
                                    icon: Icons.monetization_on_sharp,
                                  ),
                                  _buildTextFormField(
                                    controller: _quantityControllers[index],
                                    label: "Quantity",
                                    icon: Icons.numbers,
                                  ),
                                  _buildExpiryDateField(index),
                                  _buildDropdownButton(index),
                                  _buildTextFormField(
                                    controller: _unitNumberControllers[index],
                                    label: "Unit Number",
                                    icon: Icons.numbers_sharp,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      FirebaseFunctions.deletePurchaseItem(
                                          medicine.id!);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              fixedSize: Size(200, 50),
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () {
                              if (supplierIdController.text.isEmpty ||
                                  invoiceIdController.text.isEmpty ||
                                  _expiryControllers.any((controller) =>
                                      controller.text.isEmpty ||
                                      _unitNumberControllers.any((controller) =>
                                          controller.text.isEmpty)) ||
                                  _priceControllers.any((controller) =>
                                      controller.text.isEmpty) ||
                                  _quantityControllers.any((controller) =>
                                      controller.text.isEmpty) ||
                                  _selectedSmallUnits.any(
                                      (unit) => unit == null || unit.isEmpty)) {
                                // Show error message if any required field is empty
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.redAccent,
                                      title: const Text(
                                        'Error',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: const Text(
                                        "Please fill in all required fields.",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            fixedSize: const Size(150, 50),
                                            backgroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )
                                      ],
                                    );
                                  },
                                );
                                return; // Stop execution if fields are empty
                              }

                              // Loop to add purchases
                              for (int i = 0;
                                  i < _priceControllers.length;
                                  i++) {
                                PurchasesModel purchases = PurchasesModel(
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  supplierId: supplierIdController.text, //
                                  invoiceId: invoiceIdController.text, //
                                  dateOfDay: widget.dateOfDay,
                                  timeOfDay: widget.timeOfDay,
                                  medicineExpiryDate:
                                      _expiryControllers[i].text, //
                                  medicineSmallUnitNumber:
                                      _unitNumberControllers[i].text, //
                                  medicinePrice: _priceControllers[i].text, //
                                  medicineQuantity: int.parse(
                                      _quantityControllers[i].text), //
                                  medicineSmallUnit:
                                      _selectedSmallUnits[i] ?? '', //
                                  medicineName: snapshot.data![i]!.name,
                                  totalPrice: _totalPrice.value.toString(),
                                );

                                FirebaseFunctions.addMedicinesToInventory(
                                    purchases);
                              }

                              // Delete all user purchases after adding new ones
                              FirebaseFunctions.deleteUserPurchases();

                              // Show success dialog
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.blueGrey,
                                    title: const Text(
                                      'Purchase Added',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: const Text(
                                      "Purchase added successfully!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          fixedSize: const Size(150, 50),
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ValueListenableBuilder<double>(
                            valueListenable: _totalPrice,
                            builder: (context, value, child) {
                              return Text(
                                "Total Price: \$${value.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _initializeControllers(int length) {
    if (_priceControllers.length > length) {
      _priceControllers.removeRange(length, _priceControllers.length);
      _quantityControllers.removeRange(length, _quantityControllers.length);
      _expiryControllers.removeRange(length, _expiryControllers.length);
      _unitNumberControllers.removeRange(length, _unitNumberControllers.length);
      _selectedSmallUnits.removeRange(length, _selectedSmallUnits.length);
    } else {
      for (int i = _priceControllers.length; i < length; i++) {
        _priceControllers
            .add(TextEditingController()..addListener(_updateTotalPrice));
        _quantityControllers
            .add(TextEditingController()..addListener(_updateTotalPrice));
        _expiryControllers.add(TextEditingController());
        _unitNumberControllers.add(TextEditingController());
        _selectedSmallUnits.add(null);
      }
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.black),
            border: _inputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildExpiryDateField(int index) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: TextFormField(
          controller: _expiryControllers[index],
          readOnly: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: "Expiry Date",
            prefixIcon: const Icon(Icons.date_range, color: Colors.black),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.black),
              onPressed: () => _selectDate(index),
            ),
            border: _inputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton(int index) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: DropdownButtonFormField<String>(
          value: _selectedSmallUnits[index],
          decoration: InputDecoration(
            labelText: 'Small Unit',
            border: _inputBorder(),
          ),
          items: smallUnits
              .map((unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(unit, style: const TextStyle(fontSize: 14)),
                  ))
              .toList(),
          onChanged: (value) {
            _selectedSmallUnits[index] = value;
          },
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.black, width: 2.0),
      );

  Future<void> _selectDate(int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      _expiryControllers[index].text =
          DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }
}
